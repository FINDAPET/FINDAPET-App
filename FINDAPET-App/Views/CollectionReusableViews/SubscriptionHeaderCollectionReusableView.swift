//
//  SubscriptionHeaderCollectionReusableView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 29.10.2022.
//

import UIKit
import SnapKit

final class SubscriptionHeaderCollectionReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: SubscriptionHeaderCollectionReusableView.self)
    
//    MARK: UI Properties
    private let infoLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Premium subscriptions increase the views of each of your deals. Premium subscriptions are available for 1, 3, 6 months and 1 year and can be automatically renewed.", comment: String())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        
        self.addSubview(self.infoLabel)
        
        self.infoLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview().inset(15)
        }
    }
    
}
