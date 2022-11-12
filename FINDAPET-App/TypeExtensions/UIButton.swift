//
//  UIButton.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 12.11.2022.
//

import Foundation
import UIKit
import SnapKit

extension UIButton {
    
    func imageViewSizeToButton() {
        self.imageView?.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
