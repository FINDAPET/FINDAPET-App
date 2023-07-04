//
//  InfoViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 27.10.2022.
//

import UIKit
import SnapKit

class InfoViewController: UIViewController {
    
    private let presenter: InfoPresenter
    
    init(presenter: InfoPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let supportingTeamLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Supporting Team", comment: "")
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 18, weight: .regular)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let advertisingTeamLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Advertising Team", comment: "")
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 18, weight: .regular)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var supportingTeamEmailLinkButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(.init(suportingTeamEmail), for: .normal)
        view.setTitleColor(.accentColor, for: .normal)
        view.addTarget(self, action: #selector(self.didTapSuppotingTeamEmailLinkButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var advertisingTeamEmailLinkButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(.init(advertisingTeamEmail), for: .normal)
        view.setTitleColor(.accentColor, for: .normal)
        view.addTarget(self, action: #selector(self.didTapAdvertisingTeamEmailLinkButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var privacyPolicyButton: UIButton = {
        let view = UIButton()
        
        view.setTitle("Go To Privacy Policy", for: .normal)
        view.setTitleColor(.accentColor, for: .normal)
        view.addTarget(self, action: #selector(self.didTapPrivacyPolicyButton), for: .touchUpInside)
        view.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.title = NSLocalizedString("Contact Info", comment: .init())
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.supportingTeamLabel)
        self.scrollView.addSubview(self.advertisingTeamLabel)
        self.scrollView.addSubview(self.supportingTeamEmailLinkButton)
        self.scrollView.addSubview(self.advertisingTeamEmailLinkButton)
        self.scrollView.addSubview(self.privacyPolicyButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.supportingTeamLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalToSuperview().inset(15)
        }
        
        self.supportingTeamEmailLinkButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(self.supportingTeamLabel.snp.trailing).inset(-15)
            make.centerY.equalTo(self.supportingTeamLabel)
        }
        
        self.advertisingTeamLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.supportingTeamLabel.snp.bottom).inset(-10)
        }
        
        self.advertisingTeamEmailLinkButton.snp.makeConstraints { make in
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(self.advertisingTeamLabel.snp.trailing).inset(-15)
            make.centerY.equalTo(self.advertisingTeamLabel)
        }
        
        self.privacyPolicyButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.advertisingTeamLabel.snp.bottom).inset(-15)
        }
    }
    
//    MARK: Actions
    @objc private func didTapPrivacyPolicyButton() {
        self.presenter.goToPrivacyPolicy()
    }
    
    @objc private func didTapSuppotingTeamEmailLinkButton() {
        self.presenter.goToSupportingTeamMail()
    }
    
    @objc private func didTapAdvertisingTeamEmailLinkButton() {
        self.presenter.goToAdvertisingTeamMail()
    }
    
}
