//
//  UIView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 20.10.2022.
//

import Foundation
import UIKit

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
                
                if i == 0 {
                    view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                    view.layer.cornerRadius = 10
                } else if i == fields.count - 1 {
                    view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                    view.layer.cornerRadius = 10
                }
                
                return view
            }()
            
            textField.snp.makeConstraints { make in
                make.height.equalTo(50)
            }
            
            stackView.addArrangedSubview(textField)
        }
        
        return mainStackView
    }
    
}
