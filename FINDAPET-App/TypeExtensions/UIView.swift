//
//  UIView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.10.2022.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view)
        }
    }
        
    func pinMenuTo(_ view: UIView, with constant: CGFloat, side: HamburgerViewSides) {
        view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.snp.makeConstraints { make in
            make.top.bottom.equalTo(view)
            
            switch side {
            case .left:
                make.leading.equalTo(view)
                make.trailing.equalTo(view).inset(-constant)
            case .right:
                make.trailing.equalTo(view)
                make.leading.equalTo(view).inset(-constant)
            }
        }
    }
    
}
