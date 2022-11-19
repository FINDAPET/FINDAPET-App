//
//  SexCollectionViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 19.11.2022.
//

import UIKit
import SnapKit

class SexCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: SexCollectionViewCell.self)
    
    var isMale: Bool? {
        didSet {
            guard let isMale = self.isMale else {
                return
            }
            
            self.sexLabel.text = NSLocalizedString(isMale ? "Male" : "Female", comment: .init())
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.layer.borderWidth = 3
            } else {
                self.layer.borderWidth = .zero
            }
        }
    }
    
//    MARK: UI Properties
    private let sexLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 24
        self.layer.borderColor = UIColor.accentColor.cgColor
        self.backgroundColor = .textFieldColor
        
        self.addSubview(self.sexLabel)
        
        self.sexLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
    }
    
}
