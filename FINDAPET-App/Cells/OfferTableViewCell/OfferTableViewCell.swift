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
    var offer: Offer.Output? {
        didSet {
            guard let offer = self.offer else {
                return
            }
            
            if let data = offer.deal.photoDatas.first {
                self.dealImageView.image = UIImage(data: data)
            }
            
            self.nameLabel.text = offer.deal.title
            self.priceLabel.text = "\(offer.deal.price) \(offer.deal.currencyName)"
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
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textColor = .textColor
        view.numberOfLines = .zero
        view.textAlignment = .center
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
        self.addSubview(self.nameLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.messageButton)
        
        if self.acceptButtonAction != nil {
            self.stackView.addArrangedSubview(self.acceptButton)
        }
        
        self.dealImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(100)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.dealImageView.snp.trailing).inset(-15)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-15)
            make.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.dealImageView.snp.trailing).inset(-15)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(self.priceLabel.snp.bottom).inset(-15)
            make.leading.trailing.bottom.equalToSuperview().inset(-15)
        }
        
        self.acceptButton.snp.makeConstraints { make in
            make.width.equalTo(self.messageButton)
        }
    }
    
//    MARK: Actions
    @objc private func didTapMessageButton() {
        self.messageButtonAction?()
    }
    
    @objc private func didTapAcceptButton() {
        self.acceptButtonAction?()
    }

}
