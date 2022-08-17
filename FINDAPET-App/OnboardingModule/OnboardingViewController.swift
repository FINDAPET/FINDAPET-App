//
//  OnboardingViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    private let presenter: OnboardingPresenter
    
    init(presenter: OnboardingPresenter) {
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
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "<#image name#>")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let textLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.text = NSLocalizedString("FINDAPET is a convenient app for buying and selling purebred animals from catteries all over the world.", comment: "")
        view.font = .systemFont(ofSize: 18, weight: .regular)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var signInButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Sign In", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .accentColor
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.signInButtonDidTap), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var logInButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Log In", comment: ""), for: .normal)
        view.setTitleColor(.textColor, for: .normal)
        view.backgroundColor = .clear
        view.addTarget(self, action: #selector(self.logInButtonDidTap), for: .touchUpInside)
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
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.textLabel)
        self.scrollView.addSubview(self.signInButton)
        self.scrollView.addSubview(self.logInButton)
        
        self.scrollView.snp.makeConstraints { make in
            make.width.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.logoImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalToSuperview()
            make.height.equalTo(self.logoImageView.snp.width)
        }
        
        self.textLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.logoImageView.snp.bottom).inset(-10)
        }
        
        self.signInButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.textLabel.snp.bottom).inset(-15)
            make.height.equalTo(50)
        }
        
        self.logInButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.signInButton.snp.bottom).inset(-10)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
//    MARK: Actions
    
    @objc private func logInButtonDidTap() {
        self.presenter.goToLogIn()
    }
    
    @objc private func signInButtonDidTap() {
        self.presenter.goToSignIn()
    }

}
