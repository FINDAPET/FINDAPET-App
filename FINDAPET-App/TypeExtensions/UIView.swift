//
//  UIView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 20.10.2022.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    
//    MARK: TextFields Factory
    func createTextFieldsView(title: String, fields: [(placeholder: String, text: String?, action: (UITextField) -> Void)]) -> UIStackView {
        let label: UILabel = {
            let view = UILabel()
            
            view.text = title
            view.textColor = .textColor
            view.font = .systemFont(ofSize: 20, weight: .bold)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let stackView: UIStackView = {
            let view = UIStackView()
            
            view.axis = .vertical
            view.spacing = -0.5
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let mainStackView: UIStackView = {
            let view = UIStackView()
            
            view.axis = .vertical
            view.spacing = 15
            view.layer.cornerRadius = 10
            view.addArrangedSubview(label)
            view.addArrangedSubview(stackView)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        for i in 0 ..< fields.count {
            let textField: CustomTextField = {
                let view = CustomTextField(action: fields[i].action)
                
                view.placeholder = fields[i].placeholder
                view.text = fields[i].text
                view.textColor = .textColor
                view.backgroundColor = .textFieldColor
                view.layer.borderColor = UIColor.lightGray.cgColor
                view.layer.borderWidth = 0.5
                view.tintColor = .accentColor
                view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
                view.leftViewMode = .always
                view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
                view.rightViewMode = .always
                view.translatesAutoresizingMaskIntoConstraints = false
                
                if .zero != fields.count - 1 {
                    if i == 0 {
                        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                        view.layer.cornerRadius = 10
                    } else if i == fields.count - 1 {
                        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                        view.layer.cornerRadius = 10
                    }
                } else {
                    view.layer.cornerRadius = 25
                }
                
                return view
            }()
            
            textField.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            
            stackView.addArrangedSubview(textField)
        }
        
        if stackView.arrangedSubviews.count == 1 {
            stackView.layer.cornerRadius = 25
        }
        
        return mainStackView
    }
    
//    MARK: Contain View
    func containView() -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(self)
        
        self.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(15)
        }
        
        return view
    }
    
//    MARK: Create Key Value Stack View
    func createKeyValueStackView(key: String, value: String) -> UIStackView {
        let keyLabel: UILabel = {
            let view = UILabel()
            
            view.text = "\(key):"
            view.textColor = .textColor
            view.adjustsFontSizeToFitWidth = true
            view.setContentHuggingPriority(.required, for: .horizontal)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let valueLabel: UILabel = {
            let view = UILabel()
            
            view.text = value
            view.textColor = .textColor
            view.adjustsFontSizeToFitWidth = true
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        let stackView: UIStackView = {
            let view = UIStackView()
            
            view.axis = .horizontal
            view.spacing = 10
            view.addArrangedSubviews(keyLabel, valueLabel)
            view.translatesAutoresizingMaskIntoConstraints = false
            
            return view
        }()
        
        return stackView
    }
    
//    MARK: - Creage Key Value Label
    func createKeyValueLabel(key: String, value: String) -> UILabel {
        let view = UILabel()
        
        view.text = "\(key): \(value)"
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 17)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
}
