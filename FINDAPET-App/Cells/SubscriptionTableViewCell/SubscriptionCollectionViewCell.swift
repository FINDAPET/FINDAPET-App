//
//  SubscriptionTableViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 25.10.2022.
//

import UIKit
import SnapKit
import StoreKit

class SubscriptionCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let cellID = String(describing: SubscriptionCollectionViewCell.self)
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.backgroundColor = .accentColor
                self.nameLabel.textColor = .white
                self.priceLabel.textColor = .white
            } else {
                self.backgroundColor = .textFieldColor
                self.nameLabel.textColor = .textColor
                self.priceLabel.textColor = .textColor
            }
        }
    }
    
    var product: SKProduct? {
        didSet {
            self.nameLabel.text = self.product?.localizedDescription
            self.priceLabel.text = "\(self.product?.price.stringValue ?? .init())\(self.product?.priceLocale.currencySymbol ?? .init())"
        }
    }
    
//    MARK: UI Properties
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        view.numberOfLines = .zero
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .textFieldColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.priceLabel)
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(self.snp.centerY).inset(7.5)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).inset(-15)
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }
    
}
