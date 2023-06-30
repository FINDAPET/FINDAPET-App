//
//  NotificationScreenViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 09.12.2022.
//

import UIKit
import SnapKit
import WebKit
import JGProgressHUD

final class NotificationScreenViewController: UIViewController {

//   MARK: - Properties
    private let presenter: NotificationScreenPresenter
    
    
//    MARK: - Init
    init(presenter: NotificationScreenPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var webView: WKWebView = {
        let view = WKWebView()
        
        view.backgroundColor = .clear
        view.isHidden = self.presenter.notificationScreen.webViewURL == nil
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let progressIndicator: JGProgressHUD = {
        let view = JGProgressHUD()
        
        view.textLabel.text = NSLocalizedString("Loading", comment: .init())
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.presenter.notificationScreen.title
        view.textColor = .hexStringToUIColor(hex: self.presenter.notificationScreen.textColorHEX ?? .init()) ?? .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.isHidden = self.presenter.notificationScreen.webViewURL != nil
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.isHidden = self.presenter.notificationScreen.webViewURL != nil
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .hexStringToUIColor(
            hex: self.presenter.notificationScreen.buttonColorHEX
        ) ?? .accentColor
        view.setTitle(self.presenter.notificationScreen.buttonTitle, for: .normal)
        view.setTitleColor(
            .hexStringToUIColor(hex: self.presenter.notificationScreen.buttonTitleColorHEX) ?? .white,
            for: .normal
        )
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.presenter.notificationScreen.text
        view.textColor = .hexStringToUIColor(hex: self.presenter.notificationScreen.textColorHEX ?? .init()) ?? .textColor
        view.font = .systemFont(ofSize: 17)
        view.numberOfLines = .zero
        view.isHidden = self.presenter.notificationScreen.webViewURL != nil
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let view = UIImageView(image: .init(data: self.presenter.notificationScreen.backgroundImageData))
        
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.webView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.button)
        self.view.insertSubview(self.webView, at: 1)
        self.view.insertSubview(self.titleLabel, at: 1)
        self.view.insertSubview(self.scrollView, at: 1)
        self.view.insertSubview(self.button, at: 1)

        self.scrollView.addSubview(self.textLabel)

        self.backgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }

        self.webView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.button)
        }

        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
        }

        self.button.snp.makeConstraints { make in
            make.top.equalTo(self.scrollView.snp.bottom).inset(-15)
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(50)
        }

        self.textLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalTo(self.view).inset(15)
        }
    }
    
//    MARK: - Load Web View
    private func loadWebView() {
        guard let str = self.presenter.notificationScreen.webViewURL,
              let url = URL(string: str) else { return }
        
        self.webView.load(.init(url: url))
    }
    
//    MARK: Actions
    @objc private func didTapButton() {
        self.dismiss(animated: true)
        
        guard var notificationScreensID = self.presenter.getUserDefaultsNotificationScreensID(),
              let id = self.presenter.notificationScreen.id else {
            return
        }
        
        notificationScreensID.append(id.uuidString)
                
        self.presenter.setUserDefaultsNotificationScreensID(notificationScreensID)
    }
    
}

//MARK: - Extensions
extension NotificationScreenViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressIndicator.show(in: self.view)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressIndicator.dismiss(animated: true)
    }
    
}
