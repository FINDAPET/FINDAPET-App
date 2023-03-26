//
//  ChatRoomTableViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import UIKit
import SnapKit

final class ChatRoomTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
        self.setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: ChatRoomTableViewCell.self)
    
    var chatRoom: ChatRoom.Output? {
        didSet {
            guard let chatRoom = self.chatRoom else {
                return
            }
            
            if let user = chatRoom.users.filter({ [ weak self ] user in user.id != self?.getUserID() }).first,
               let avatarData = user.avatarData {
                self.avatarImageView.image = .init(data: avatarData)
                self.nameLabel.text = user.name
            }
            
            let count = chatRoom.messages.filter { [ weak self ] message in
                message.user.id != self?.getUserID() && !message.isViewed
            }.count
            
            self.lastMessageLabel.text = self.chatRoom?.messages.sorted {
                ISO8601DateFormatter().date(from: $0.createdAt ?? .init()) ?? .init() <
                    ISO8601DateFormatter().date(from: $1.createdAt ?? .init()) ?? .init()
            }.first?.text
            self.notViewedMessagesCountLabel.text = "\(count)"
            
            if count != .zero {
                self.notViewedMessagesCountLabel.isHidden = false
            }
        }
    }
    
//    MARK: UI Properties
    private let avatarImageView: UIImageView = {
        let view = UIImageView(image: .init(named: "empty avatar"))
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let lastMessageLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let notViewedMessagesCountLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .systemFont(ofSize: 17)
        view.backgroundColor = .accentColor
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.isHidden = true
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        
        self.addSubview(self.avatarImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.lastMessageLabel)
        self.addSubview(self.notViewedMessagesCountLabel)
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(15)
            make.width.height.equalTo(100)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.top.trailing.equalToSuperview().inset(15)
        }
        
        self.lastMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-10)
            make.trailing.equalTo(self.notViewedMessagesCountLabel.snp.leading).inset(-10)
        }
        
        self.notViewedMessagesCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(self.lastMessageLabel)
            make.height.width.equalTo(30)
        }
    }
    
//    MARK: Setup Actions
    private func setupActions() {
        NotificationCenterManager.addObserver(
            self,
            name: .hideNotViewedMessagesCountLabelInChatRoomWithID,
            additional: self.chatRoom?.id,
            action: #selector(self.hideNotViewedMessagesCountLabelAction)
        )
    }
    
//    MARK: Edititng
    func hideNotViewedMessagesCountLabel() {
        self.notViewedMessagesCountLabel.isHidden = true
    }
    
//    MARK: User Defautls
    private func getUserID() -> UUID? {
        guard let string = UserDefaultsManager.read(key: .id) as? String else {
            return nil
        }
        
        return .init(uuidString: string)
    }
    
//    MARK: Actions
    @objc private func hideNotViewedMessagesCountLabelAction() {
        self.notViewedMessagesCountLabel.isHidden = true
    }

}
