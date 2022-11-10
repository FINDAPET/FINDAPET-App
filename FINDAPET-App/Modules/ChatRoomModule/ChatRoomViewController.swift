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

    private let preseter: ChatRoomPresenter
    
    init(preseter: ChatRoomPresenter) {
        self.preseter = preseter
        
        super.init(nibName: nil, bundle: nil)
        
        self.preseter.callBack = { [ weak self ] in
            self?.messagesCollectionView.reloadData()
            self?.messagesCollectionView.scrollToLastItem()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.preseter.closeWS()
    }
    
//    MARK: UI Properties
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
    
    private lazy var chatRoomHeaderView: ChatRoomHeaderView = {
        let view = ChatRoomHeaderView()
        
        view.user = self.preseter.chatRoom?.users.filter { [ weak self ] in $0.id != self?.preseter.getUserID() }.first
        view.didTapAvatarImageViewAction = self.preseter.goToProfile
        view.didTapBackButtonAction = { [ weak self ] in self?.navigationController?.popViewController(animated: true) }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
        
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.preseter.chatRoom == nil {
            self.activityIndicatorView.isHidden = false
            
            self.preseter.getChatRoom { [ weak self ] _, error in
                self?.error(error) { [ weak self ] in
                    self?.messagesCollectionView.scrollToLastItem()
                    self?.activityIndicatorView.isHidden = true
                }
            }
        }
        
        self.preseter.chatRoom()
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
    }
    
//    MARK: Configure Messages Collection View
    private func configureMessagesCollectionView() {
        self.messagesCollectionView.backgroundColor = .clear
        self.messagesCollectionView.messagesDataSource = self
        self.messagesCollectionView.messagesLayoutDelegate = self
        self.messagesCollectionView.messagesDisplayDelegate = self
        self.messagesCollectionView.scrollToLastItem()
        self.preseter.callBack?()
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
    }
    
}

//MARK: Extension
extension ChatRoomViewController: MessagesDataSource {
    
    var currentSender: MessageKit.SenderType {
        self.preseter.chatRoom?.users.filter { [ weak self ] user in user.id == self?.preseter.getUserID() }.first ?? User.Output(
            id: self.preseter.getUserID(),
            name: self.preseter.getUserName() ?? String(),
            deals: [Deal.Output](),
            boughtDeals: [Deal.Output](),
            ads: [Ad.Output](),
            myOffers: [Offer.Output](),
            offers: [Offer.Output](),
            chatRooms: [ChatRoom.Output](),
            isPremiumUser: true
        )
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        self.preseter.chatRoom?.messages.sorted { $0.sentDate < $1.sentDate }[indexPath.section] ?? Message.Output(
            text: String(),
            user: User.Output(
                id: self.preseter.getUserID(),
                name: self.preseter.getUserName() ?? String(),
                deals: [Deal.Output](),
                boughtDeals: [Deal.Output](),
                ads: [Ad.Output](),
                myOffers: [Offer.Output](),
                offers: [Offer.Output](),
                chatRooms: [ChatRoom.Output](),
                isPremiumUser: true
            ),
            chatRoom: ChatRoom.Output(users: [User.Output](), messages: [Message.Output]())
        )
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        self.preseter.chatRoom?.messages.count ?? .zero
    }
    
}

extension ChatRoomViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == self.preseter.getUserID()?.uuidString {
            return .accentColor
        }
        
        return .textFieldColor
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == self.preseter.getUserID()?.uuidString {
            return .white
        }
        
        return .textColor
    }
    
}

extension ChatRoomViewController: InputBarAccessoryViewDelegate {
        
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.preseter.sendMessage(Message.Input(
            text: text,
            userID: self.preseter.getUserID() ?? UUID(),
            chatRoomID: self.preseter.chatRoom?.id
        ))
        self.messagesCollectionView.scrollToLastItem()
        
        inputBar.inputTextView.text = String()
    }
    
}

extension ChatRoomViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        .zero
    }
    
}
