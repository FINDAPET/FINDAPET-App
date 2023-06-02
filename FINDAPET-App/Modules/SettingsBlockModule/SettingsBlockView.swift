//
//  SettingsBlockView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 21.10.2022.
//

import UIKit
import SnapKit

final class SettingsBlockView: UIView {
    
    private let presenter: SettingsBlockPresenter
    
    init(presenter: SettingsBlockPresenter) {
        self.presenter = presenter
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Properties
    private let currencyLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.text = NSLocalizedString("Currency", comment: "") + ":"
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let countryLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.text = NSLocalizedString("Country", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let cityLabel: UILabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.text = NSLocalizedString("City", comment: "")
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var countryTextField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .textFieldColor
        view.textColor = .textColor
        view.placeholder = NSLocalizedString("Country", comment: "")
        view.layer.cornerRadius = 10
        view.text = self.presenter.getUserCountry()
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var cityTextField: UITextField = {
        let view = UITextField()
        
        view.backgroundColor = .textFieldColor
        view.textColor = .textColor
        view.placeholder = NSLocalizedString("City", comment: "")
        view.layer.cornerRadius = 10
        view.text = self.presenter.getUserCity()
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.leftViewMode = .always
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        view.rightViewMode = .always
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var currencyValueLabel: UILabel = {
        let view = UILabel()
        
        view.text = self.presenter.getUserCurrency() ?? Currency.USD.rawValue
        view.font = .systemFont(ofSize: 24)
        view.textColor = .textColor
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCurrencyValueTextField)))
        view.isUserInteractionEnabled = true
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        
        view.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .accentColor
        view.layer.cornerRadius = 25
        view.addTarget(self, action: #selector(self.didTapSaveButton), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }

//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .backgroundColor
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(UIInputViewController.dismissKeyboard)
        ))
        
        self.addSubview(self.countryLabel)
        self.addSubview(self.countryTextField)
        self.addSubview(self.cityLabel)
        self.addSubview(self.cityTextField)
        self.addSubview(self.currencyLabel)
        self.addSubview(self.currencyValueLabel)
        self.addSubview(self.saveButton)
        
        self.countryTextField.snp.makeConstraints { make in
            make.top.equalTo(self.countryLabel.snp.bottom).inset(-15)
            make.trailing.leading.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        self.countryLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(15)
        }
        
        self.cityTextField.snp.makeConstraints { make in
            make.top.equalTo(self.cityLabel.snp.bottom).inset(-15)
            make.trailing.leading.equalToSuperview().inset(15)
            make.height.equalTo(50)
        }
        
        self.cityLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.countryTextField.snp.bottom).inset(-15)
        }
        
        self.currencyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalTo(self.currencyValueLabel)
        }
        
        self.currencyValueLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cityTextField.snp.bottom).inset(-15)
            make.leading.equalTo(self.currencyLabel.snp.trailing).inset(-15)
            make.height.equalTo(50)
            make.width.equalTo(75)
        }
        
        self.saveButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(15)
            make.top.equalTo(self.currencyValueLabel.snp.bottom).inset(-15)
            make.height.equalTo(50)
        }
    }
    
//    MARK: Funcs
    func setupCurrencyValueText(_ text: String) {
        self.currencyValueLabel.text = text
    }
    
//    MARK: Actions
    @objc private func didTapSaveButton() {
        self.presenter.setUserCurrency(Currency.getCurrency(wtih: self.currencyValueLabel.text ?? Currency.USD.rawValue) ?? Currency.USD)
        self.presenter.setUserCountry(self.countryTextField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty ?? true ? nil : self.countryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        self.presenter.setUserCity(self.cityTextField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty ?? true ? nil : self.countryTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
        self.presenter.goTo()
        self.presenter.changeUserBaseCurrencyName(currencyName: self.currencyValueLabel.text ?? Currency.USD.rawValue)
    }
    
    @objc private func didTapCurrencyValueTextField() {
        self.presenter.currencyValueTextFieldTapAction()
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }

}

//MARK: - Extensions
extension SettingsBlockView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.countryTextField {
            self.cityTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}
