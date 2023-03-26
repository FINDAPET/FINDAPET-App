//
//  SubscriptionInformationView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.03.2023.
//

import UIKit
import SnapKit

final class SubscriptionInformationView: UIView {
    
//    MARK: - Properties
    private let presenter: SubscriptionInformationPresenter
    
    init(presenter: SubscriptionInformationPresenter) {
        self.presenter = presenter
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - UI Properties
    private let stackView: UIStackView = {
        let view = UIStackView()
        
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = "FINDAPET Premium"
        view.textColor = .white
        view.font = .init(name: "AvenirNext-Bold", size: 30)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dateLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .backgroundColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let descriptionTitleLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Description", comment: .init())
        view.textColor = .textColor
        view.font = .boldSystemFont(ofSize: 30)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Premium subscriptions increase the views of each of your deals. Premium subscriptions are available for 1, 3, 6 months and 1 year and can be automatically renewed.", comment: .init())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 20, weight: .semibold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupValues()
        self.setupViews()
    }
    
//    MARK: - Setup Values
    func setupValues() {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        guard let date = self.presenter.getPremiumUserDate() else {
            return
        }
        
        self.dateLabel.text = "\(NSLocalizedString("Valid until", comment: .init())) \(dateFormatter.string(from: date))"
    }

//    MARK: - Setup Views
    private func setupViews() {
        self.backgroundColor = .accentColor
        
        self.addSubview(self.stackView)
        self.stackView.addArrangedSubviews(self.titleLabel, self.dateLabel)
        
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.descriptionTitleLabel)
        self.containerView.addSubview(self.descriptionLabel)
        
        self.stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        self.descriptionTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.descriptionTitleLabel.snp.bottom).inset(-10)
        }
    }
    
}
