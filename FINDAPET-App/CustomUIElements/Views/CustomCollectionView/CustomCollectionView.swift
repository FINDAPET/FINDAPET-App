//
//  CustomCollectionView.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 06.01.2023.
//

import UIKit

final class CustomCollectionView: UICollectionView {
    
//    MARK: Properties
    override var intrinsicContentSize: CGSize { self.contentSize }

//    MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.bounds.size != self.intrinsicContentSize {
            self.invalidateIntrinsicContentSize()
        }
    }

}
