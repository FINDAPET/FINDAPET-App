//
//  ImageWithXmarkCollectionViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 07.01.2023.
//

import UIKit

final class ImageWithXmarkCollectionView: UICollectionView {
    
//    MARK: Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    var callBack: (([UIImage]) -> Void)?
    var images = [UIImage]() {
        didSet {
            if self.images.isEmpty {
                self.isHidden = true
            } else {
                self.isHidden = false
                self.reloadData()
            }
            
            self.callBack?(self.images)
        }
    }
    
//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.dataSource = self
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.register(
            ImageWithXmarkCollectionViewCell.self,
            forCellWithReuseIdentifier: ImageWithXmarkCollectionViewCell.id
        )
    }
    
}

//MARK: Extensions
extension ImageWithXmarkCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageWithXmarkCollectionViewCell.id,
            for: indexPath
        ) as? ImageWithXmarkCollectionViewCell else {
            return .init()
        }
        
        cell.photoImageView.clipsToBounds = true
        cell.photoImageView.layer.masksToBounds = true
        cell.photoImageView.layer.cornerRadius = 25
        cell.imageData = self.images[indexPath.item].pngData()
        cell.delegate = self
        
        return cell
    }
    
}

extension ImageWithXmarkCollectionView: UICollectionViewDelegate { }

extension ImageWithXmarkCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 130, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
}

extension ImageWithXmarkCollectionView: ImageWithXmarkCollectionViewCellDelegate {
    
    func imageWithXmarkCollectionViewCell(_ cell: ImageWithXmarkCollectionViewCell, didTapXmarkButton xmarkButton: UIButton) {
        for i in 0 ..< self.images.count {
            if cell.imageData == self.images[i].pngData() {
                self.images.remove(at: i)
                
                break
            }
        }
    }
    
    func imageWithXmarkCollectionViewCell(_ cell: ImageWithXmarkCollectionViewCell, imageViewSize imageView: UIImageView) -> CGSize {
        .init(width: 100, height: 100)
    }
    
}
