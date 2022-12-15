//
//  DealDescriptionView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 31.10.2022.
//

import UIKit
import SnapKit

final class DealDescriptionView: UIView {
    
    var didTapBuyerAvatarImageViewAction: ((UUID) -> Void)?
    private let deal: Deal.Output
    
    init(deal: Deal.Output) {
        self.deal = deal
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Description", comment: String())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 28, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let descriptionStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let buyerStackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let buyerKeyLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Buyer", comment: .init())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var buyerAvastarImageView: UIImageView = {
        let view = UIImageView(image: .init(data: self.deal.buyer?.avatarData ?? .init()))
        
        view.clipsToBounds = true
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 8.5
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapBuyerAvatarImageView)))
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var buyerNameValueLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.deal.buyer?.name
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.deal.description
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var keyValueStackViews = [
        self.createKeyValueStackView(key: NSLocalizedString("Country", comment: String()), value: self.deal.country ?? String()),
        self.createKeyValueStackView(key: NSLocalizedString("City", comment: String()), value: self.deal.city ?? String()),
        self.createKeyValueStackView(
            key: NSLocalizedString("Sex", comment: String()),
            value: NSLocalizedString(self.deal.isMale ? "Male" : "Female", comment: String())
        ),
        self.createKeyValueStackView(key: NSLocalizedString("Mode", comment: String()), value: self.deal.mode),
        self.createKeyValueStackView(key: NSLocalizedString("Breed", comment: String()), value: self.deal.petBreed),
        self.createKeyValueStackView(key: NSLocalizedString("Show Class", comment: String()), value: self.deal.petClass),
        self.createKeyValueStackView(key: NSLocalizedString("Show Class", comment: String()), value: self.deal.petClass),
        self.createKeyValueStackView(key: NSLocalizedString("Age", comment: String()), value: self.deal.age),
        self.createKeyValueStackView(key: NSLocalizedString("Color", comment: String()), value: self.deal.color)
    ]
    
//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .textFieldColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 25
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionStackView)
        self.addSubview(self.buyerStackView)
        self.addSubview(self.descriptionLabel)
        
        self.buyerStackView.addArrangedSubviews(self.buyerKeyLabel, self.buyerAvastarImageView, self.buyerNameValueLabel)
                
        self.descriptionStackView.addArrangedSubviews(self.keyValueStackViews)

        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
        }
        
        self.descriptionStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.lessThanOrEqualToSuperview().inset(15)
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
        }
        
        self.buyerStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.trailing.lessThanOrEqualToSuperview().inset(15)
            make.top.equalTo(self.descriptionStackView.snp.bottom).inset(-10)
        }
        
        self.buyerAvastarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(17)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.buyerStackView.snp.bottom).inset(-15)
        }
    }
    
//    MARK: Actions
    @objc private func didTapBuyerAvatarImageView() {
        guard let id = self.deal.buyer?.id else {
            return
        }
        
        self.didTapBuyerAvatarImageViewAction?(id)
    }
    
}
