//
//  TagCollectionViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.01.2023.
//

import UIKit
import SnapKit

final class TagCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: TagCollectionViewCell.self)
    
    var value: String? {
        didSet {
            guard let value = self.value else {
                return
            }
            
            self.valueLabel.text = "#\(value)"
        }
    }
        
//    MARK: UI Properties
    private let valueLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .accentColor
        view.font = .boldSystemFont(ofSize: 20)
        view.textAlignment = .center
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .backgroundColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
        
        self.contentView.addSubview(self.valueLabel)
        
        self.valueLabel.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(15)
        }
    }
    
}
