//
//  OfferTableViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 18.10.2022.
//

import UIKit
import SnapKit

final class OfferTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let cellID = String(describing: OfferTableViewCell.self)
    
    var messageButtonAction: (() -> Void)?
    var acceptButtonAction: (() -> Void)? {
        didSet {
            self.setupViews()
        }
    }
    var buyerAvatarImageViewAction: ((UUID) -> Void)?
    var offer: Offer.Output? {
        didSet {
            guard let offer = self.offer else {
                return
            }
            
            if let data = offer.deal.photoDatas.first {
                self.dealImageView.image = UIImage(data: data)
            }
            
            if let data = offer.buyer.avatarData {
                self.avatarImageView.image = UIImage(data: data)
            }
            
            self.titleLabel.text = offer.deal.title
            self.priceLabel.text = "\(offer.deal.price) \(offer.deal.currencyName)"
            self.nameLabel.text = offer.buyer.name
        }
    }
    
//    MARK: UI Properties
    private let dealImageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .textColor
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameKeyLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Buyer", comment: String())):"
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceKeyLabel: UILabel = {
        let view = UILabel()
        
        view.text = "\(NSLocalizedString("Price", comment: String())):"
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "empty avatar"))
        
        view.layer.cornerRadius = 12.5
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .horizontal
        view.spacing = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var messageButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .accentColor
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Message", for: .normal)
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.didTapMessageButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var acceptButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .systemGreen
        view.setTitleColor(.white, for: .normal)
        view.setTitle("Accept", for: .normal)
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.didTapAcceptButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        
        self.addSubview(self.dealImageView)
        self.addSubview(self.titleLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.stackView)
        self.addSubview(self.avatarImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.nameKeyLabel)
        self.addSubview(self.priceKeyLabel)
        
        self.stackView.addArrangedSubview(self.messageButton)
        
        if self.acceptButtonAction != nil {
            self.stackView.addArrangedSubview(self.acceptButton)
        }
        
        self.dealImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(15)
            make.height.equalTo(self.dealImageView.snp.width)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dealImageView.snp.bottom).inset(-15)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        self.nameKeyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
        }
        
        self.avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(self.nameKeyLabel.snp.trailing).inset(-15)
            make.centerY.equalTo(self.nameKeyLabel)
            make.width.height.equalTo(25)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.avatarImageView.snp.trailing).inset(-15)
            make.trailing.lessThanOrEqualToSuperview().inset(15)
            make.centerY.equalTo(self.avatarImageView)
        }
        
        self.priceKeyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.nameKeyLabel.snp.bottom).inset(-15)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.priceKeyLabel)
            make.leading.equalTo(self.priceKeyLabel.snp.trailing).inset(-15)
            make.trailing.equalToSuperview().inset(15)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(self.priceLabel.snp.bottom).inset(-15)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
        }
        
        self.messageButton.snp.makeConstraints { make in
            if self.messageButton.superview?.subviews.count ?? .zero > 1 {
                make.width.equalTo(self.acceptButton)
            }
        }
    }
    
//    MARK: Actions
    @objc private func didTapMessageButton() {
        self.messageButtonAction?()
    }
    
    @objc private func didTapAcceptButton() {
        self.acceptButtonAction?()
    }
    
    @objc private func didTapBuyerAvatarImageView() {
        guard let id = self.offer?.buyer.id else {
            return
        }
        
        self.buyerAvatarImageViewAction?(id)
    }

}
