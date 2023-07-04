//
//  ChatRoomViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import UIKit
import SnapKit
import MessageKit
import InputBarAccessoryView
import JGProgressHUD

final class ChatRoomViewController: MessagesViewController {
    
//    MARK: Properties
    private let presenter: ChatRoomPresenter
    
//    MARK: Init
    init(presenter: ChatRoomPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in
            if self?.isFirstLoad ?? true {
                self?.isFirstLoad = false
                self?.messagesCollectionView.reloadData()
                self?.messagesCollectionView.scrollToLastItem(animated: false)
                
                UIView.animate(withDuration: 0.1) {
                    self?.messagesCollectionView.alpha = 1
                    self?.messageInputBar.alpha = 1
                }
            } else {
                self?.messagesCollectionView.reloadDataAndKeepOffset()
                self?.messagesCollectionView.scrollToLastItem()
                
                guard let first = self?.presenter.chatRoom?.messages.last?.user.id,
                      let second = self?.presenter.getUserID(),
                      first != second else {
                    return
                }
                
                self?.presenter.playOnGetMessageSound()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Proretries
    private var isFirstLoad = true
    
    
//    MARK: UI Properties
    private lazy var imagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.delegate = self
        view.allowsEditing = true
        view.sourceType = .photoLibrary
        view.navigationBar.tintColor = .accentColor
        
        return view
    }()
    
    private let statusBarView: UIView = {
        let view = UIView()

        view.backgroundColor = .textFieldColor
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let progressIndicator: JGProgressHUD = {
        let view = JGProgressHUD()

        view.textLabel.text = NSLocalizedString("Loading", comment: .init())

        return view
    }()

    private lazy var photosCollectionView: ImageWithXmarkCollectionView = {
        let view = ImageWithXmarkCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        view.callBack = { [ weak self ] images in
            guard let self = self else {
                return
            }

            if !images.isEmpty {
                self.messageInputBar.sendButton.isEnabled = true
            } else if self.messageInputBar.inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.messageInputBar.sendButton.isEnabled = false
            }
        }
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var chatRoomHeaderView: ChatRoomHeaderView = {
        let view = ChatRoomHeaderView()

        view.user = self.presenter.chatRoom?.users.filter { [ weak self ] in $0.id != self?.presenter.getUserID() }.first
        view.didTapAvatarImageViewAction = self.presenter.goToProfile
        view.didTapBackButtonAction = { [ weak self ] in self?.navigationController?.popViewController(animated: true) }
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var paperclipButton: UIButton = {
        let view = UIButton()

        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "paperclip"), for: .normal)
        } else {
            view.setImage(.init(named: "paperclip")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        view.tintColor = .lightGray
        view.imageViewSizeToButton()
        view.addTarget(self, action: #selector(self.didTapPaperclipButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var browseImagesViewController = self.presenter.getBrowseImage(self)

//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.setupViews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.presenter.chatRoom?.id == nil {
            self.progressIndicator.show(in: self.view, animated: true)

            self.presenter.getChatRoom { [ weak self ] _, error in
                self?.progressIndicator.dismiss(animated: true)

                guard self?.presenter.chatRoom?.messages.filter({ $0.id != self?.presenter.getUserID() && !$0.isViewed }).count ?? .zero != .zero else {
                    return
                }
                
                self?.presenter.viewAllMessages()
                self?.presenter.notificationCenterManagerHideNotViewedMessagesCountLabel()
            }
        } else {
            self.presenter.viewAllMessages()
            self.presenter.notificationCenterManagerHideNotViewedMessagesCountLabel()
        }

        self.presenter.chatRoom()

        guard !(self.presenter.chatRoom?.messages.isEmpty ?? true) else {
            return
        }
        
        self.messagesCollectionView.scrollToLastItem(animated: false)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard self.isFirstLoad, self.presenter.chatRoom?.id != nil else { return }

        self.isFirstLoad = false
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem(animated: false)

        UIView.animate(withDuration: 0.2) { [ weak self ] in
            self?.messagesCollectionView.alpha = 1
            self?.messageInputBar.alpha = 1
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.isFirstLoad = true
        self.presenter.closeWS()
        self.presenter.notificationCenterManagerMakeChatRoomsEmpty()
        self.presenter.notificationCenterManagerMakeChatRoomsRefreshing()
    }

//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.isHidden = true
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)
        ))
        
        self.configureMessagesCollectionView()
        self.configureMessageInputBar()

        self.view.addSubview(self.statusBarView)
        self.view.addSubview(self.chatRoomHeaderView)

        for constraint in self.view.constraints {
            self.view.removeConstraint(constraint)
        }

        self.statusBarView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(50)
        }

        self.chatRoomHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.messagesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.chatRoomHeaderView.snp.bottom)
        }

        self.paperclipButton.snp.makeConstraints { make in
            make.width.equalTo(23.67)
            make.height.equalTo(23.67)
        }

        self.photosCollectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }

//    MARK: Configure Messages Collection View
    private func configureMessagesCollectionView() {
        self.messagesCollectionView.backgroundColor = .clear
        self.messagesCollectionView.alpha = .zero
        self.messagesCollectionView.messagesDataSource = self
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        self.messagesCollectionView.messageCellDelegate = self
        self.scrollsToLastItemOnKeyboardBeginsEditing = true
        self.maintainPositionOnKeyboardFrameChanged = true
    }

//    MARK: Configure Message Input Bar
    private func configureMessageInputBar() {
        self.messageInputBar.alpha = .zero
        self.messageInputBar.delegate = self
        self.messageInputBar.backgroundView.backgroundColor = .textFieldColor
        self.messageInputBar.inputTextView.backgroundColor = .textFieldColor

        if #available(iOS 13.0, *) {
            self.messageInputBar.sendButton.setImage(.init(systemName: "arrow.up"), for: .normal)
        } else {
            self.messageInputBar.sendButton.setImage(.init(named: "arrow.up")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        self.messageInputBar.sendButton.setTitle(nil, for: .normal)
        self.messageInputBar.sendButton.backgroundColor = .textFieldColor
        self.messageInputBar.sendButton.tintColor = .accentColor
        self.messageInputBar.inputTextView.tintColor = .accentColor
        self.messageInputBar.sendButton.imageView?.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        self.messageInputBar.leftStackView.insertArrangedSubview(self.paperclipButton, at: .zero)
        self.messageInputBar.leftStackView.alignment = .center
        self.messageInputBar.bottomStackView.addArrangedSubview(self.photosCollectionView)
        self.messageInputBar.setLeftStackViewWidthConstant(to: 23.67, animated: false)
        self.messageInputBar.shouldManageSendButtonEnabledState = false
    }

//    MARK: Actions
    @objc private func didTapPaperclipButton() {
        self.present(self.imagePickerController, animated: true)
    }

    @objc private func keyboadWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.messagesCollectionView.contentInset.bottom = keyboardSize.height
            self.messagesCollectionView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height,
                right: 0
            )
            self.messagesCollectionView.setContentOffset(.init(
                x: 0,
                y: max(self.messagesCollectionView.contentSize.height - self.messagesCollectionView.bounds.size.height, 0)
            ), animated: true)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.messagesCollectionView.contentInset.bottom = .zero
        self.messagesCollectionView.verticalScrollIndicatorInsets = .zero
    }

    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

}

//MARK: Extension
extension ChatRoomViewController: UINavigationControllerDelegate { }
extension ChatRoomViewController: MessagesDataSource {
    
    func currentSender() -> MessageKit.SenderType {
        User.SenderType(senderId: self.presenter.myID?.uuidString ?? .init(), displayName: self.presenter.myName ?? .init())
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        guard let message = self.presenter.chatRoom?.messages.sorted(by: {
            $0.createdAt ?? .init() < $1.createdAt ?? .init()
        })[indexPath.section] else {
            return Message.MessageType(
                sender: User.SenderType(
                    senderId: self.presenter.getUserID()?.uuidString ?? .init(),
                    displayName: self.presenter.getUserName() ?? .init()
                ),
                messageId: .init(),
                sentDate: .init(),
                kind: .text(.init())
            )
        }

        guard let data = message.bodyData, let image = UIImage(data: data) else {
            return Message.MessageType(
                sender: User.SenderType(senderId: message.user.id?.uuidString ?? .init(), displayName: message.user.name),
                messageId: message.id?.uuidString ?? .init(),
                sentDate: ISO8601DateFormatter().date(from: message.createdAt ?? .init()) ?? .init(),
                kind: .text(message.text ?? .init())
            )
        }

        return Message.MessageType(
            sender: User.SenderType(senderId: message.user.id?.uuidString ?? .init(), displayName: message.user.name),
            messageId: message.id?.uuidString ?? .init(),
            sentDate: ISO8601DateFormatter().date(from: message.createdAt ?? .init()) ?? .init(),
            kind: .photo(Message.MediaItem(size: image.size, image: image, placeholderImage: image))
        )
    }

    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        self.presenter.chatRoom?.messages.count ?? .zero
    }

}

extension ChatRoomViewController: MessagesDisplayDelegate {

    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        self.isFromCurrentSender(message: message) ? .accentColor : .textFieldColor
    }

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        self.isFromCurrentSender(message: message) ? .white : .textColor
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        .bubbleTail(self.isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft, .pointedEdge)
    }
    
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView
    ) {
        avatarView.isHidden = true
    }

}

extension ChatRoomViewController: MessageCellDelegate {

    func didTapImage(in cell: MessageCollectionViewCell) {
        if #available(iOS 13.0, *) {
            guard let index = self.presenter.chatRoom?.messages.map(\.bodyData).firstIndex(of: cell.largeContentImage?.pngData()),
                  let viewController = self.browseImagesViewController else {
                return
            }

            self.navigationController?.pushViewController(viewController, animated: true)

            viewController.scrollToImage(at: .init(item: index, section: .zero))
        }

        guard let cell = cell as? MediaMessageCell,
              let index = self.presenter.chatRoom?.messages.map(\.bodyData).firstIndex(of: cell.imageView.image?.pngData()),
              let viewController = self.browseImagesViewController else {
            return
        }

        self.navigationController?.pushViewController(viewController, animated: true)

        viewController.scrollToImage(at: .init(item: index, section: .zero))
    }

}

extension ChatRoomViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let datas = self.photosCollectionView.images.map({ $0.jpegData(compressionQuality: 0.7) }).filter({ $0 != nil }) as? [Data] {
            for data in datas {
                print(data)

                self.presenter.sendMessage(.init(
                    bodyData: data,
                    userID: self.presenter.getUserID() ?? .init(),
                    chatRoomID: self.presenter.chatRoom?.id
                ))
            }

            self.photosCollectionView.images = .init()
        }

        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        self.presenter.sendMessage(.init(
            text: text.trimmingCharacters(in: .whitespacesAndNewlines),
            userID: self.presenter.getUserID() ?? .init(),
            chatRoomID: self.presenter.chatRoom?.id
        ))
        self.messagesCollectionView.scrollToLastItem()
        inputBar.inputTextView.text = nil

        ///Maybe later. If it will be needed
//        self.presenter.playOnSendMessageSound()

        guard self.presenter.chatRoom?.id == nil else { return }

        self.presenter.addID()
    }

    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.messageInputBar.sendButton.isEnabled = true
        } else if self.photosCollectionView.images.isEmpty {
            self.messageInputBar.sendButton.isEnabled = false
        }
    }

}

extension ChatRoomViewController: MessagesLayoutDelegate {

    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? { .zero }

}

extension ChatRoomViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        self.photosCollectionView.images.append(image)

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

}

extension ChatRoomViewController: BrowseImagesViewControllerDataSource {

    func browseImagesViewController(_ viewController: BrowseImagesViewController, collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.chatRoom?.messages.filter { $0.bodyData != nil }.count ?? .zero
    }

    func browseImagesViewController(_ viewController: BrowseImagesViewController, collectionView: UICollectionView, imageForItemAt indexPath: IndexPath) -> UIImage? {
        guard let data = self.presenter.chatRoom?.messages.filter({ $0.bodyData != nil }).map({ $0.bodyData })[indexPath.item] else { return nil }

        return .init(data: data)
    }

}
