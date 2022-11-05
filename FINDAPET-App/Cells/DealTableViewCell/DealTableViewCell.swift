//
//  DealTableViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.10.2022.
//

import UIKit
import SnapKit

class DealTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let cellID = String(describing: DealTableViewCell.self)
    
    var deal: Deal.Output? {
        didSet {
            guard let deal = self.deal else {
                return
            }
            
            if let data = deal.photoDatas.first {
                self.photoImageView.image = UIImage(data: data)
            }
            
            self.titleLabel.text = deal.title
            self.priceLabel.text = "\(deal.price) \(deal.currencyName)"
        }
    }

//    MARK: UIProperties
    private let containerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .textFieldColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.textAlignment = .left
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24)
        view.textAlignment = .right
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    
    private func setupViews() {
        self.backgroundColor = .clear
        
        self.addSubview(self.containerView)
        
        self.containerView.addSubview(self.photoImageView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.priceLabel)
        
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(7.5)
        }
        
        self.photoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
            make.height.equalTo(self.photoImageView.snp.width)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.photoImageView.snp.bottom).inset(-15)
            make.width.equalTo(self.titleLabel).dividedBy(0.7).inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.titleLabel.snp.trailing).inset(-15)
            make.top.equalTo(self.photoImageView.snp.bottom).inset(-15)
        }
    }

}
