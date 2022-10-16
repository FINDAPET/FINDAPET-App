//
//  InformationTabelViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 16.10.2022.
//

import UIKit
import SnapKit

final class InformationTabelViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        
        
    }
    
}
