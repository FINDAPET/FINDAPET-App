//
//  PhotoCollectionViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import UIKit
import SnapKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: PhotoCollectionViewCell.self)
    
    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
    
//    MARK: UI Properties
    let imageView: UIImageView = {
        let view = UIImageView()
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        self.addSubview(self.imageView)
        
        self.imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
}
