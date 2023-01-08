//
//  ImageWithXmarkView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 06.01.2023.
//

import UIKit
import SnapKit

//MARK: ImageWithXmarkViewDelegate Protocol
@objc protocol ImageWithXmarkCollectionViewCellDelegate: NSObjectProtocol {
    @objc optional func imageWithXmarkCollectionViewCell(_ cell: ImageWithXmarkCollectionViewCell, didTapImageView imageView: UIImageView)
    @objc optional func imageWithXmarkCollectionViewCell(_ cell: ImageWithXmarkCollectionViewCell, didTapXmarkButton xmarkButton: UIButton)
    @objc optional func imageWithXmarkCollectionViewCell(_ cell: ImageWithXmarkCollectionViewCell, imageViewSize imageView: UIImageView) -> CGSize
}

//MARK: ImageWithXmarkView Class
open class ImageWithXmarkCollectionViewCell: UICollectionViewCell {

//    MARK: Prperties
    static let id = String(describing: ImageWithXmarkCollectionViewCell.self)
    
    var delegate: ImageWithXmarkCollectionViewCellDelegate?
    var image: UIImage? {
        didSet {
            self.photoImageView.image = self.image
        }
    }
    
//    MARK: Init
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UIProperties
    lazy var photoImageView: UIImageView = {
        let view = UIImageView(image: self.image)
        
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(self.didTapImageView(_:)))
        )
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var xmarkButton: UIButton = {
        let view = UIButton()
        
        view.backgroundColor = .white
        view.setImage(.init(systemName: "xmark.circle.fill"), for: .normal)
        view.tintColor = .lightGray
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 15
        view.imageViewSizeToButton()
        view.addTarget(self, action: #selector(self.didTapXmarkButton(_:)), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.backgroundColor = .clear
        
        self.addSubview(self.photoImageView)
        self.addSubview(self.xmarkButton)
        
        self.photoImageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(15)
            
            if let size = self.delegate?.imageWithXmarkCollectionViewCell?(
                self,
                imageViewSize: self.photoImageView
            ) {
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }
        
        self.xmarkButton.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.trailing.top.equalToSuperview()
        }
    }
    
//    MARK: Actions
    @objc private func didTapImageView(_ sender: UIImageView) {
        self.delegate?.imageWithXmarkCollectionViewCell?(self, didTapImageView: sender)
    }
    
    @objc private func didTapXmarkButton(_ sender: UIButton) {
        self.delegate?.imageWithXmarkCollectionViewCell?(self, didTapXmarkButton: sender)
    }
    
}
