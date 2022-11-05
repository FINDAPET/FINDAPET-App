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
    
    static let id = String(describing: ProfileTableViewCell.self)
    
    var user: User.Output? {
        didSet {
            guard let user = user else {
                return
            }
            
            if let avatarData = user.avatarData {
                self.avatarImageView.image = UIImage(data: avatarData) ?? UIImage(named: "empty avatar")
            }
            
            self.nameLabel.text = user.name
            self.descriptionLabel.text = user.description
        }
    }
    
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
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 75
        view.clipsToBounds = true
        view.layer.masksToBounds = true
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
        
        view.numberOfLines = 5
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(self.didTapDescriptionLabel(_:))
        ))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var checkmarkImageView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "checkmark"))
        
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
        
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.avatarImageView)
        self.containerView.addSubview(self.nameLabel)
        self.containerView.addSubview(self.descriptionLabel)
        
        self.avatarImageView.addSubview(self.checkmarkImageView)
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(150)

            if self.descriptionLabel.frame.maxY <= self.avatarImageView.frame.maxY {
                make.bottom.equalToSuperview().inset(15)
            }
        }
        
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(7.5)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.avatarImageView)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-15)

            if self.descriptionLabel.frame.maxY > self.avatarImageView.frame.maxY {
                make.bottom.equalToSuperview().inset(15)
            }
        }
        
        self.checkmarkImageView.snp.makeConstraints { make in
            make.bottom.leading.equalToSuperview()
            make.width.height.equalTo(15)
        }
    }
    
//    MARK: Actions
    
    @objc private func didTapDescriptionLabel(_ sender: UILabel) {
        UIView.animate(withDuration: 0.3) { [ weak self ] in
            if sender.numberOfLines == .zero {
                self?.descriptionLabel.numberOfLines = 5
            } else if sender.numberOfLines == 5 {
                self?.descriptionLabel.numberOfLines = .zero
            }
        }
        
        self.avatarImageView.snp.removeConstraints()
        self.descriptionLabel.snp.removeConstraints()
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(150)
            make.bottom.greaterThanOrEqualToSuperview().inset(15)
            
            if self.descriptionLabel.frame.maxY < self.avatarImageView.frame.maxY {
                make.bottom.equalToSuperview().inset(15)
            }
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-15)
            
            if self.descriptionLabel.frame.maxY >= self.avatarImageView.frame.maxY {
                make.bottom.equalToSuperview().inset(15)
            }
        }
    }

}
