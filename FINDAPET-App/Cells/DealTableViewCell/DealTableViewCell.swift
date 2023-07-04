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
    
//    MARK: - Properties
    static let cellID = String(describing: DealTableViewCell.self)
    
    var deal: Deal.Output? {
        didSet {
            guard let deal = self.deal else { return }
                        
            if let data = deal.photoDatas.first {
                self.photoImageView.image = UIImage(data: data)
            }
            
            self.titleLabel.text = deal.title
            self.priceLabel.text = deal.price != nil ? "\(Int(deal.price?.rounded(.up) ?? .zero)) \(deal.currencyName)" :
            NSLocalizedString("Price as agreed", comment: .init())
            self.officialCatteryLabel.isHidden = deal.cattery.avatarData == nil
            
            if let date = ISO8601DateFormatter().date(from: deal.birthDate) {
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "dd.MM.yyyy"
                
                self.birthDateLabel.text = dateFormatter.string(from: date)
            }
            
            if let country = deal.country {
                self.locationLabel.text = country
                
                if let city = deal.city {
                    self.locationLabel.text! += ", \(city)"
                }
                
                return
            }
            
            if let city = deal.city {
                self.locationLabel.text = city
            }
        }
    }

//    MARK: - UI Properties
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
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let locationLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let birthDateLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 16)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var officialCatteryLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Official Cattery", comment: .init())
        view.textColor = .accentColor
        view.font = .systemFont(ofSize: 16, weight: .semibold)
        view.numberOfLines = .zero
        view.isHidden = self.deal?.cattery.avatarData == nil
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: - Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.containerView)
        
        self.containerView.addSubview(self.photoImageView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.priceLabel)
        self.containerView.addSubview(self.locationLabel)
        self.containerView.addSubview(self.birthDateLabel)
        self.containerView.addSubview(self.officialCatteryLabel)
        
        self.containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(7.5)
        }
        
        self.photoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(-10)
            make.height.equalTo(self.photoImageView.snp.width)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.photoImageView.snp.bottom).inset(-15)
        }
        
        self.priceLabel.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview().inset(15)
            make.top.equalTo(self.titleLabel.snp.bottom).inset(-15)
        }
        
        self.locationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.priceLabel.snp.bottom).inset(-10)
        }
                        
        self.birthDateLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.locationLabel.snp.bottom).inset(-10)
        }
        
        self.officialCatteryLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.birthDateLabel.snp.bottom).inset(-10)
        }
    }

}
