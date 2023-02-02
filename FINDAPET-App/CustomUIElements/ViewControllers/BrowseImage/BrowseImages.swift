//
//  BrowseImage.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 01.02.2023.
//

import UIKit
import SnapKit

//MARK: - Browse Image View Controller Delegate
protocol BrowseImagesViewControllerDataSource {
    func browseImagesViewController(
        _ viewController: BrowseImagesViewController,
        collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int
    func browseImagesViewController(
        _ viewController: BrowseImagesViewController,
        collectionView: UICollectionView,
        imageForItemAt indexPath: IndexPath
    ) -> UIImage?
}

//MARK: - Browse Images View Controller

open class BrowseImagesViewController: UIViewController {
    
//    MARK: - Properties
    var dataSource: BrowseImagesViewControllerDataSource?
    
//    MARK: - UI Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.dataSource = self
        view.delegate = self
        view.register(
            ResizableImageCollectionViewCell.self,
            forCellWithReuseIdentifier: ResizableImageCollectionViewCell.id
        )
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: .init())
        
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.collectionView.snp.width)
        }
    }
    
}

//MARK: - Extensions
extension BrowseImagesViewController {
    
    public func scrollToImage(at indexPath: IndexPath, animated: Bool = false) {
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
    
}

extension BrowseImagesViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.dataSource?.browseImagesViewController(
            self,
            collectionView: collectionView,
            numberOfItemsInSection: section
        ) ?? .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ResizableImageCollectionViewCell.id,
            for: indexPath
        ) as? ResizableImageCollectionViewCell else {
            return .init()
        }
        
        cell.image = self.dataSource?.browseImagesViewController(
            self,
            collectionView: collectionView,
            imageForItemAt: indexPath
        )
        
        return cell
    }
    
}

extension BrowseImagesViewController: UICollectionViewDelegate { }

extension BrowseImagesViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: self.view.bounds.width, height: self.view.bounds.width)
    }
    
}
