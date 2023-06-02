//
//  NotificationScreenViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 09.12.2022.
//

import UIKit
import SnapKit

final class NotificationScreenViewController: UIViewController {

    private let presenter: NotificationScreenPresenter
    
    init(presenter: NotificationScreenPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.presenter.notificationScreen.title
        view.textColor = .hexStringToUIColor(hex: self.presenter.notificationScreen.textColorHEX) ?? .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .hexStringToUIColor(
            hex: self.presenter.notificationScreen.buttonColorHEX
        ) ?? .accentColor
        view.setTitle(self.presenter.notificationScreen.text, for: .normal)
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
        view.textColor = .hexStringToUIColor(hex: self.presenter.notificationScreen.textColorHEX) ?? .textColor
        view.font = .systemFont(ofSize: 17)
        view.numberOfLines = .zero
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(self.backgroundImageView)
        
        self.backgroundImageView.addSubview(self.titleLabel)
        self.backgroundImageView.addSubview(self.scrollView)
        self.backgroundImageView.addSubview(self.button)
        
        self.scrollView.addSubview(self.textLabel)
        
        self.backgroundImageView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
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
            make.leading.trailing.equalTo(self.backgroundImageView).inset(15)
        }
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
