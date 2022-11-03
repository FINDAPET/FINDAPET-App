//
//  CreateOfferViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 02.11.2022.
//

import UIKit
import SnapKit

final class CreateOfferViewController: UIViewController {
    
    var callBack: (() -> Void)?
    private let presenter: CreateOfferPresenter
    
    init(presenter: CreateOfferPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private let dealImageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceTextField: UITextField = {
        let view = UITextField()
        
        view.keyboardType = .numberPad
        view.textColor = .textColor
        view.tintColor = .accentColor
        view.backgroundColor = .textFieldColor
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.placeholder = NSLocalizedString("Price", comment: String())
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var currencyButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .lightGray
        view.setTitle(self.presenter.getUserDefautlsCurrency(), for: .normal)
        view.setTitleColor(.accentColor, for: .normal)
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 25
        view.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        view.addTarget(self, action: #selector(self.didTapCurrencyButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var sendButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Send", comment: String()), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .accentColor
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.didTapSendButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupValues()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        
        self.view.addSubview(self.dealImageView)
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.priceTextField)
        self.view.addSubview(self.currencyButton)
        self.view.addSubview(self.sendButton)
        
        self.dealImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(100)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalTo(self.dealImageView)
            make.leading.equalTo(self.dealImageView.snp.trailing).inset(-15)
        }
        
        self.priceTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.dealImageView.snp.bottom).inset(-15)
            make.height.equalTo(50)
        }
        
        self.currencyButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.priceTextField)
            make.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.priceTextField.snp.trailing)
            make.height.equalTo(50)
            make.width.equalTo(70)
        }
        
        self.sendButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.currencyButton.snp.bottom).inset(-15)
        }
    }
    
//    MARK: Setup Values
    private func setupValues() {
        if let data = self.presenter.deal.photoDatas.first {
            self.dealImageView.image = .init(data: data)
        }
        
        self.titleLabel.text = self.presenter.deal.title
        self.priceTextField.text = String(self.presenter.deal.price)
    }
    
//    MARK: Actions
    @objc private func didTapSendButton() {
        guard !(self.priceTextField.text?.isEmpty ?? true) else {
            print("❌ Error: price field is empty.")
            
            self.presentAlert(title: NSLocalizedString("The price field shouldn't be empty", comment: String()))
            
            return
        }
        
        self.presenter.createOffer(
            price: Int(self.priceTextField.text ?? String()) ?? self.presenter.deal.price,
            currencyName: .getCurrency(wtih: self.currencyButton.titleLabel?.text ?? String()) ?? .USD
        ) { [ weak self ] error in
            self?.error(error) {
                self?.callBack?()
                self?.presenter.notificationCenterManagerPostUpdateProfileScreen()
            }
        }
    }
    
    @objc private func didTapCurrencyButton() {
        self.presentActionsSheet(
            title: NSLocalizedString("Currency", comment: String()),
            contents: Currency.allCases.map { $0.rawValue }) { [ weak self ] alertAction in
                self?.currencyButton.setTitle(alertAction.title, for: .normal)
            }
    }
    
}
