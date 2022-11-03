//
//  UIStackView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 31.10.2022.
//

import Foundation
import UIKit

extension UIStackView {
    
//    MARK: Add Arranged Subviews
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
}
