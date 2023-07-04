//
//  PetTypeCollectionViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.11.2022.
//

import UIKit
import SnapKit

final class PetTypeCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: PetTypeCollectionViewCell.self)
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {                
                self.layer.borderWidth = 3
            } else {
                self.layer.borderWidth = .zero
            }
        }
    }
    
    var petType: PetType.Entity? {
        didSet {
            guard let petType = self.petType else {
                return
            }
                        
            self.imageView.image = .init(data: petType.imageData)
            self.nameLabel.text = petType.name
        }
    }
    
//    MARK: UI Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        
        view.textColor = .white
        view.font = .systemFont(ofSize: 24, weight: .bold)
        view.textAlignment = .right
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 25
        self.layer.borderColor = UIColor.accentColor.cgColor
        self.contentView.isUserInteractionEnabled = true
        
        self.contentView.addSubview(self.imageView)
        
        self.imageView.addSubview(self.nameLabel)
        
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
}
