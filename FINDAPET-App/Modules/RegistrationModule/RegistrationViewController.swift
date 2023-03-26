//
//  RegistrationViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 17.08.2022.
//

import UIKit
import SnapKit
import JGProgressHUD

final class RegistrationViewController: UIViewController {

    private let presenter: RegistrationPresenter
    
    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properites
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        
        view.image = UIImage(named: "logo")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let emailTextField: UITextField = {
        let view = UITextField()
         
        view.textColor = .textColor
        view.font = UIFont.systemFont(ofSize: 16)
        view.autocapitalizationType = .none
        view.backgroundColor = .textFieldColor
        view.placeholder = "Email"
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
         
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let view = UITextField()
         
        view.textColor = .textColor
        view.font = UIFont.systemFont(ofSize: 16)
        view.autocapitalizationType = .none
        view.backgroundColor = .textFieldColor
        view.isSecureTextEntry = true
        view.placeholder = NSLocalizedString("Password", comment: "")
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 0))
        view.rightViewMode = .always
         
        return view
    }()
    
    private lazy var showPasswordImageView: UIImageView = {
        if #available(iOS 13.0, *) {
            let view = UIImageView(image: .init(systemName: "eye.slash"))
            
            view.tintColor = .lightGray
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapShowPasswordImageView(_:))))
            view.isUserInteractionEnabled = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }
        
        let view = UIImageView(image: .init(named: "eye.slash")?.withRenderingMode(.alwaysTemplate))
        
        view.tintColor = .lightGray
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapShowPasswordImageView(_:))))
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var privacyPolicyButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("By clicking the button you agree to the privacy policy", comment: ""), for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 20)
        view.titleLabel?.numberOfLines = .zero
        view.tintColor = .accentColor
        
        if #available(iOS 13.0, *) {
            view.setTitleColor(.link, for: .normal)
        } else {
            view.setTitleColor(.systemBlue, for: .normal)
        }
        
        view.addTarget(self, action: #selector(self.didTapPrivacyPolicyButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var registrationButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(
            NSLocalizedString(self.presenter.mode == .logIn ? "Log In" : "Sign In", comment: ""),
            for: .normal
        )
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .accentColor
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.registrationButtonDidTap), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let progressIndicator: JGProgressHUD = {
        let view = JGProgressHUD()
        
        view.textLabel.text = NSLocalizedString("Loading", comment: .init())
        
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
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboadWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.logoImageView)
        self.scrollView.addSubview(self.emailTextField)
        self.scrollView.addSubview(self.passwordTextField)
        self.scrollView.addSubview(self.privacyPolicyButton)
        self.scrollView.addSubview(self.registrationButton)
        
        self.passwordTextField.addSubview(self.showPasswordImageView)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.width.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
            make.width.height.equalTo(250)
        }
        
        self.emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.logoImageView.snp.bottom).inset(-50)
            make.height.equalTo(50)
        }
        
        self.passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.emailTextField.snp.bottom)
            make.height.equalTo(50)
        }
        
        self.showPasswordImageView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(15)
            make.width.equalTo(self.showPasswordImageView.snp.height).multipliedBy(1.25)
        }
        
        self.privacyPolicyButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.passwordTextField.snp.bottom).inset(-15)
        }
        
        self.privacyPolicyButton.titleLabel?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        self.registrationButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.top.equalTo(self.privacyPolicyButton.snp.bottom).inset(-50)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
//    MARK: Actions
    @objc private func registrationButtonDidTap() {
        switch self.presenter.mode {
        case .logIn:
            self.progressIndicator.show(in: self.view, animated: true)
            self.presenter.auth(
                email: self.emailTextField.text ?? .init(),
                password: self.passwordTextField.text ?? .init()
            ) { [ weak self ] token, error in
                self?.progressIndicator.dismiss(animated: true)
                self?.error(error) {
                    guard let token = token else {
                        self?.presentAlert(title: NSLocalizedString("Failed to make a request", comment: ""))
                        
                        return
                    }
                    
                    self?.presenter.writeKeychainBearer(token: token.value)
                    self?.presenter.writeUserID(id: token.user.id)
                    self?.presenter.setCurrency(token.user.basicCurrencyName)
                    
                    if token.user.name.isEmpty {
                        let user = User.Input(
                            id: token.user.id,
                            name: token.user.name,
                            description: token.user.description,
                            isCatteryWaitVerify: token.user.isCatteryWaitVerify
                        )
                        
                        self?.presenter.goToEditProfile(user: user)
                    } else {
                        self?.presenter.goToMainTabBar()
                    }
                }
            }
        case .signIn:
            self.progressIndicator.show(in: self.view, animated: true)
            self.presenter.createUser(
                user: .init(
                    email: self.emailTextField.text ?? .init(),
                    password: self.emailTextField.text ?? .init()
                )
            ) { [ weak self ] error in
                self?.progressIndicator.dismiss(animated: true)
                self?.presenter.auth(
                    email: self?.emailTextField.text ?? .init(),
                    password: self?.emailTextField.text ?? .init()
                ) { token, error in
                    self?.presenter.setCurrencyRequest { _ in
                        self?.error(error) { [ weak self ] in
                            guard let token = token else {
                                self?.presentAlert(title: NSLocalizedString("Failed to make a request", comment: ""))
                                
                                return
                            }
                                                        
                            self?.presenter.writeKeychainBearer(token: token.value)
                            self?.presenter.writeUserID(id: token.user.id)
                            self?.presenter.setCurrency(token.user.basicCurrencyName)
                            
                            let user = User.Input(
                                id: token.user.id,
                                name: token.user.name,
                                description: token.user.description,
                                isCatteryWaitVerify: token.user.isCatteryWaitVerify
                            )
                            
                            self?.presenter.goToEditProfile(user: user)
                        }
                    }
                }
            }
        }
    }
    
    @objc private func keyboadWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentInset.bottom = keyboardSize.height
            self.scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height,
                right: 0
            )
            self.scrollView.setContentOffset(CGPoint(x: 0, y: max(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0) ), animated: true)
        }
    }
    
    @objc private func didTapShowPasswordImageView(_ sender: UIImageView) {
        if self.passwordTextField.isSecureTextEntry {
            if #available(iOS 13.0, *) {
                self.showPasswordImageView.image = .init(systemName: "eye")
            } else {
                self.showPasswordImageView.image = .init(named: "eye")?.withRenderingMode(.alwaysTemplate)
            }
            
            self.showPasswordImageView.tintColor = .lightGray
        } else {
            if #available(iOS 13.0, *) {
                self.showPasswordImageView.image = .init(systemName: "eye.slash")
            } else {
                self.showPasswordImageView.image = .init(named: "eye.slash")?.withRenderingMode(.alwaysTemplate)
            }
            
            self.showPasswordImageView.setNeedsDisplay()
            self.showPasswordImageView.tintColor = .lightGray
        }
        
        self.passwordTextField.isSecureTextEntry.toggle()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset.bottom = .zero
        self.scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    @objc private func didTapPrivacyPolicyButton() {
        self.presenter.goToPrivacyPolicy()
    }

}
