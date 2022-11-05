//
//  AdTableViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.10.2022.
//

import UIKit
import SnapKit

class AdTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let cellID = String(describing: AdTableViewCell.self)
    
    var ad: Ad.Output? {
        didSet {
            guard let ad = self.ad else {
                return
            }
            
            self.contentImageView.image = UIImage(data: ad.contentData)
            self.nameLabel.text = ad.custromerName
            
            if let data = ad.cattery?.avatarData {
                self.avatarImageView.image = UIImage(data: data)
                
                self.nameLabel.snp.removeConstraints()
                self.nameLabel.snp.makeConstraints { make in
                    make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
                    make.centerY.equalTo(self.avatarImageView)
                }
            } else {
                self.avatarImageView.isHidden = true
                
                self.nameLabel.snp.removeConstraints()
                self.nameLabel.snp.makeConstraints { make in
                    make.leading.top.trailing.equalToSuperview().inset(15)
                }
            }
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
        
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        view.textColor = .textColor
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let contentImageView: UIImageView = {
        let view = UIImageView()
        
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .backgroundColor
        
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.contentImageView)
        self.containerView.addSubview(self.nameLabel)
        self.containerView.addSubview(self.avatarImageView)
        
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(15)
        }
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(15)
            make.width.height.equalTo(50)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(self.avatarImageView)
        }
        
        self.contentImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.avatarImageView.snp.bottom).inset(-15)
            make.height.equalTo(self.contentImageView.snp.width)
        }
    }

}
