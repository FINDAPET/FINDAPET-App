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
    var deal: Deal.Output? {
        didSet {
            guard let deal = self.deal else {
                return
            }
            
            if let data = deal.photoDatas.first {
                self.photoImageView.image = UIImage(data: data)
            }
        }
    }

//    MARK: UIProperties
    private let photoImageView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    
    private func setupViews() {
        self.backgroundColor = .clear
        
        
    }

}
