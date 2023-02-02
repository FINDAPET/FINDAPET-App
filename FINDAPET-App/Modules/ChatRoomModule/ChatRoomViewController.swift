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

final class ChatRoomViewController: MessagesViewController {

    private let presenter: ChatRoomPresenter
    
    init(preseter: ChatRoomPresenter) {
        self.presenter = preseter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToLastItem()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.presenter.closeWS()
    }
        
//    MARK: UI Properties
    private lazy var imagePickerController: UIImagePickerController = {
        let view = UIImagePickerController()
        
        view.delegate = self
        view.allowsEditing = true
        view.sourceType = .photoLibrary
        
        return view
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        
        view.startAnimating()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let statusBarView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .textFieldColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
            } else if self.messageInputBar.inputTextView.text.isEmpty {
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
        
        view.setImage(.init(systemName: "paperclip"), for: .normal)
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
        
        if self.presenter.chatRoom == nil {
            self.activityIndicatorView.isHidden = false
            
            self.presenter.getChatRoom { [ weak self ] _, error in
                self?.error(error) { [ weak self ] in
                    self?.messagesCollectionView.scrollToLastItem()
                    self?.activityIndicatorView.isHidden = true
                    
                    if self?.presenter.chatRoom?.messages.filter({ $0.id != self?.presenter.getUserID() && !$0.isViewed }).count ?? .zero != .zero {
                        self?.presenter.viewAllMessages()
                        self?.presenter.notificationCenterManagerHideNotViewedMessagesCountLabel()
                    }
                }
            }
        }
        
        self.presenter.chatRoom()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
                
        self.configureMessagesCollectionView()
        self.configureMessageInputBar()
        
        self.view.addSubview(self.statusBarView)
        self.view.addSubview(self.chatRoomHeaderView)
        self.view.addSubview(self.activityIndicatorView)
        
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
        
        self.messageInputBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
        self.messagesCollectionView.messagesDataSource = self
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        self.messagesCollectionView.messageCellDelegate = self
        self.messagesCollectionView.scrollToLastItem()
        self.presenter.callBack?()
    }
    
//    MARK: Configure Message Input Bar
    private func configureMessageInputBar() {
        self.messageInputBar.delegate = self
        self.messageInputBar.backgroundColor = .textFieldColor
        self.messageInputBar.inputTextView.backgroundColor = .textFieldColor
        self.messageInputBar.sendButton.setImage(.init(systemName: "arrow.up"), for: .normal)
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
    
}

//MARK: Extension
extension ChatRoomViewController: UINavigationControllerDelegate { }

extension ChatRoomViewController: MessagesDataSource {
    
    var currentSender: MessageKit.SenderType {
        self.presenter.chatRoom?.users.filter { [ weak self ] user in user.id == self?.presenter.getUserID() }.first ?? User.Output(
            id: self.presenter.getUserID(),
            name: self.presenter.getUserName() ?? String(),
            deals: [Deal.Output](),
            boughtDeals: [Deal.Output](),
            ads: [Ad.Output](),
            myOffers: [Offer.Output](),
            offers: [Offer.Output](),
            chatRooms: [ChatRoom.Output](),
            isPremiumUser: .random()
        )
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        self.presenter.chatRoom?.messages.sorted { $0.sentDate < $1.sentDate }[indexPath.section] ?? Message.Output(
            text: String(),
            isViewed: .random(),
            user: User.Output(
                id: self.presenter.getUserID(),
                name: self.presenter.getUserName() ?? String(),
                deals: [Deal.Output](),
                boughtDeals: [Deal.Output](),
                ads: [Ad.Output](),
                myOffers: [Offer.Output](),
                offers: [Offer.Output](),
                chatRooms: [ChatRoom.Output](),
                isPremiumUser: .random()
            ),
            chatRoom: ChatRoom.Output(users: [User.Output](),messages: [Message.Output]())
        )
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        self.presenter.chatRoom?.messages.count ?? .zero
    }
    
}

extension ChatRoomViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == self.presenter.getUserID()?.uuidString {
            return .accentColor
        }
        
        return .textFieldColor
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == self.presenter.getUserID()?.uuidString {
            return .white
        }
        
        return .textColor
    }
    
}

extension ChatRoomViewController: MessageCellDelegate {
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let index = self.presenter.chatRoom?.messages
            .map({ $0.bodyData })
            .firstIndex(of: cell.largeContentImage?.pngData()),
              let viewController = self.browseImagesViewController else {
            return
        }
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
        viewController.scrollToImage(at: .init(item: index, section: .zero))
    }
    
}

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if let datas = self.photosCollectionView.images
            .map({ $0.jpegData(compressionQuality: 0.7) }).filter({ $0 != nil }) as? [Data] {
            for data in datas {
                self.presenter.sendMessage(.init(
                    bodyData: data,
                    userID: self.presenter.getUserID() ?? .init(),
                    chatRoomID: self.presenter.chatRoom?.id
                ))
            }
            
            self.photosCollectionView.images = .init()
        }
        
        guard !text.isEmpty else {
            return
        }
        
        self.presenter.sendMessage(.init(
            text: text,
            userID: self.presenter.getUserID() ?? .init(),
            chatRoomID: self.presenter.chatRoom?.id
        ))
        self.messagesCollectionView.scrollToLastItem()
        
        inputBar.inputTextView.text = .init()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if !text.isEmpty {
            self.messageInputBar.sendButton.isEnabled = true
        } else if self.photosCollectionView.images.isEmpty {
            self.messageInputBar.sendButton.isEnabled = false
        }
    }
    
}

extension ChatRoomViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        .zero
    }
    
}

extension ChatRoomViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
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
        guard let data = self.presenter.chatRoom?.messages
            .filter({ $0.bodyData != nil })
            .map({ $0.bodyData })[indexPath.item] else {
            return nil
        }
        
        return .init(data: data)
    }
    
}
