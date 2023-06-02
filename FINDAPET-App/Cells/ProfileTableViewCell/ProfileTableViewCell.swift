//
//  ProfileTableViewHeaderFooterView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.08.2022.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: ProfileTableViewCell.self)
    
    var didTapChervonDescriptionButtonAction: (() -> Void)?
    var didTapAvatarImageViewAction: ((UIImageView) -> Void)?
    var user: User.Output? {
        didSet {
            guard let user = user else {
                return
            }
            
            if let avatarData = user.avatarData {
                self.avatarImageView.image = .init(data: avatarData) ?? .init(named: "empty avatar")
            }
            
            self.nameLabel.text = user.name
            self.descriptionLabel.text = user.description
            self.descriptionLabel.isHidden = user.description?.isEmpty ?? true
            self.checkmarkImageView.isHidden = user.documentData == nil
            self.chevronDescriptionButton.isHidden = user.description?.isEmpty ?? true
        }
    }
    
    private var chevronDescriptionButtonIsDown = true
    
//    MARK: UI Properties
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView(image: .init(named: "empty avatar"))
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = view.bounds.width / 2
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapAvatarImageView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        
        view.numberOfLines = .zero
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var chevronDescriptionButton: UIButton = {
        let view = UIButton()
        
        if #available(iOS 13.0, *) {
            view.setImage(.init(systemName: "chevron.down"), for: .normal)
        } else {
            view.setImage(.init(named: "chevron.down")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        
        view.tintColor = .accentColor
        view.addTarget(self, action: #selector(self.didTapChevronDescriptionButton(_:)), for: .touchUpInside)
        view.imageViewSizeToButton()
        view.isHidden = self.user?.description?.isEmpty ?? true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        if #available(iOS 13.0, *) {
            let view = UIImageView(image: UIImage(systemName: "checkmark"))
            
            view.tintColor = .accentColor
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        let view = UIImageView(image: UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate))
        
        view.tintColor = .accentColor
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
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.avatarImageView)
        self.containerView.addSubview(self.nameLabel)
        self.containerView.addSubview(self.descriptionLabel)
        self.containerView.addSubview(self.chevronDescriptionButton)
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(self.containerView.snp.width).multipliedBy(0.4)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(7.5)
            
            if self.chevronDescriptionButtonIsDown {
                make.height.equalTo(180)
            }
        }
        
        self.nameLabel.snp.removeConstraints()
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            
            guard self.user?.documentData == nil else {
                make.top.equalToSuperview().inset(15)
                
                return
            }
            
            make.top.trailing.equalToSuperview().inset(15)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-15)
        }
        
        self.chevronDescriptionButton.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom)
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalTo(self.descriptionLabel)
            make.width.height.equalTo(22)
        }
        
        self.avatarImageView.layer.cornerRadius = (self.contentView.bounds.width - 30) * 0.4 / 2
        
        guard self.user?.documentData != nil else { return }
        
        self.containerView.addSubview(self.checkmarkImageView)
        
        self.checkmarkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.nameLabel.snp.trailing).inset(-5)
            make.centerY.equalTo(self.nameLabel)
            make.width.height.equalTo(30)
        }
    }
    
//    MARK: Actions
    @objc private func didTapChevronDescriptionButton(_ sender: UIButton) {
        if self.chevronDescriptionButtonIsDown {
            if #available(iOS 13.0, *) {
                self.chevronDescriptionButton.setImage(.init(systemName: "chevron.up"), for: .normal)
            } else {
                self.chevronDescriptionButton.setImage(
                    .init(named: "chevron.up")?.withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
            }
            
            self.containerView.snp.removeConstraints()
            self.containerView.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(7.5)
            }
        } else {
            if #available(iOS 13.0, *) {
                self.chevronDescriptionButton.setImage(.init(systemName: "chevron.down"), for: .normal)
            } else {
                self.chevronDescriptionButton.setImage(
                    .init(named: "chevron.down")?.withRenderingMode(.alwaysTemplate),
                    for: .normal
                )
            }
            
            self.containerView.snp.removeConstraints()
            self.containerView.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(7.5)
                make.height.equalTo(180)
            }
        }
        
        self.chevronDescriptionButton.tintColor = .accentColor
        self.chevronDescriptionButtonIsDown.toggle()
        self.didTapChervonDescriptionButtonAction?()
    }
    
    @objc private func didTapAvatarImageView() {
        self.didTapAvatarImageViewAction?(self.avatarImageView)
    }

}
