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
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    private let languageCode: String = {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? .init()
        } else {
            return Locale.current.languageCode ?? .init()
        }
    }()
    
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
        
        view.axis = .horizontal
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
    
    private let commentTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Comment", comment: .init())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 28, weight: .bold)
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
    
    private lazy var keyValueStackViews: [UILabel] = [
        self.createKeyValueLabel(
            key: NSLocalizedString("Sex", comment: String()),
            value: NSLocalizedString(self.deal.isMale ? "Male" : "Female", comment: String())
        ),
        self.createKeyValueLabel(key: NSLocalizedString("Sold", comment: String()), value: self.deal.mode),
        self.createKeyValueLabel(key: NSLocalizedString("Breed", comment: String()), value: self.deal.petBreed.name),
        self.createKeyValueLabel(
            key: NSLocalizedString("Show Class", comment: .init()),
            value: self.deal.petClass.rawValue
        ),
        self.createKeyValueLabel(
            key: NSLocalizedString("Pet Type", comment: .init()),
            value: self.deal.petType.localizedNames[self.languageCode] ??
            self.deal.petType.localizedNames["en"] ?? .init()),
        self.createKeyValueLabel(key: NSLocalizedString("Age", comment: .init()), value: { [ weak self ] in
            guard let string = self?.deal.birthDate, let date = ISO8601DateFormatter().date(from: string) else {
                return "–"
            }

            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "dd.MM.yyyy"

            return dateFormatter.string(from: date)
        }()),
        self.createKeyValueLabel(key: NSLocalizedString("Color", comment: String()), value: self.deal.color)
    ]
        
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .textFieldColor
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 25
        self.buyerStackView.isHidden = self.deal.buyer == nil
        self.commentTitleLabel.isHidden = self.deal.description == nil
        self.descriptionLabel.isHidden = self.deal.description == nil
        
        if let country = self.deal.country {
            self.keyValueStackViews.append(self.createKeyValueLabel(
                key: NSLocalizedString("Country", comment: .init()),
                value: country
            ))
        }
        
        if let city = self.deal.city {
            self.keyValueStackViews.append(self.createKeyValueLabel(
                key: NSLocalizedString("City", comment: .init()),
                value: city
            ))
        }
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.descriptionStackView)
        self.addSubview(self.buyerStackView)
        self.addSubview(self.commentTitleLabel)
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

        self.commentTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.buyerStackView.snp.bottom).inset(-15)
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.commentTitleLabel.snp.bottom).inset(-10)
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
