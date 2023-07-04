//
//  ResizableImageCollectionViewCell.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 02.02.2023.
//

import UIKit
import SnapKit

final class ResizableImageCollectionViewCell: UICollectionViewCell {
    
//    MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Properties
    static let id = String(describing: ResizableImageCollectionViewCell.self)
    
    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
    
//    MARK: UI Properties
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.minimumZoomScale = 1
        view.maximumZoomScale = 5
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Setup Views
    private func setupViews() {
        self.contentView.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.imageView)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        self.imageView.snp.makeConstraints { make in
            make.height.width.equalTo(self)
        }
    }
    
}

//MARK: Extesions
extension ResizableImageCollectionViewCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
    
}
