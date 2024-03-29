//
//  CustomTextField.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.08.2022.
//

import Foundation
import UIKit

final class CustomTextField: UITextField {
    
    private let action: (UITextField) -> Void
    
    init(action: @escaping (UITextField) -> Void) {
        self.action = action
        
        super.init(frame: CGRect(x: 1, y: 1, width: 1, height: 1))
        
        self.addTarget(self, action: #selector(objcAction), for: .allEditingEvents)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func objcAction() {
        action(self)
    }
    
}
