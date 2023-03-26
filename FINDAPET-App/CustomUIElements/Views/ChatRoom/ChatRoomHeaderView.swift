//
//  ChatRoomMessageReusableView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 09.11.2022.
//

import UIKit
import SnapKit

class ChatRoomHeaderView: UIView {
    
//    MARK: Properties
    var user: User.Output? {
        didSet {
            guard let user = self.user else {
                return
            }
            
            if let data = user.avatarData {
                self.avatarImageView.image = .init(data: data)
            }
            
            self.nameLabel.text = user.name
        }
    }
    var didTapAvatarImageViewAction: (() -> Void)?
    var didTapBackButtonAction: (() -> Void)?
    
//    MARK: UI Properties
    private lazy var backButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "chevron.backward"), for: .normal)
        } else {
            view.setImage(.init(named: "chevron.backward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        view.tintColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapBackButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView(image: .init(named: "empty avatar"))
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapAvatarImageView)))
        view.isUserInteractionEnabled = true
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
    
//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .textFieldColor
        
        self.addSubview(self.backButton)
        self.addSubview(self.avatarImageView)
        self.addSubview(self.nameLabel)
        
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalTo(self.avatarImageView)
            make.width.equalTo(20)
            make.height.equalTo(30)
        }
        
        self.backButton.imageView?.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.avatarImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalTo(self.backButton.snp.trailing).inset(-15)
            make.width.height.equalTo(50)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(self.avatarImageView)
        }
    }
    
//    MARK: Actions
    @objc private func didTapAvatarImageView() {
        self.didTapAvatarImageViewAction?()
    }
    
    @objc private func didTapBackButton() {
        self.didTapBackButtonAction?()
    }
    
}
