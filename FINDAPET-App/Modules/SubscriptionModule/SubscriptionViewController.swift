//
//  SubscriptionViewController.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 24.10.2022.
//

import UIKit
import SnapKit

final class SubscriptionViewController: UIViewController {

    private let presenter: SubscriptionPresenter
    
    init(presenter: SubscriptionPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
        
        self.presenter.callBack = { [ weak self ] in self?.collectionView.reloadData() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: UI Propeties
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let infoLabel: UILabel = {
        let view = UILabel()
        
        view.text = NSLocalizedString("Premium subscriptions increase the views of each of your deals. Premium subscriptions are available for 1, 3, 6 months and 1 year and can be automatically renewed.", comment: String())
        view.textColor = .textColor
        view.font = .systemFont(ofSize: 24)
        view.numberOfLines = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: SubscriptionCollectionViewCell.cellID)
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.getSubscriptionProducts()
    }
    
//    MARK: Setup Views
    private func setupViews() {
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        self.title = NSLocalizedString("Subscription", comment: String())
        
        self.view.addSubview(self.scrollView)
        
        self.scrollView.addSubview(self.collectionView)
        self.scrollView.addSubview(self.infoLabel)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(15)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.infoLabel.snp.bottom).inset(-15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
        }
    }

}

extension SubscriptionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubscriptionCollectionViewCell.cellID, for: indexPath) as? SubscriptionCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.product = self.presenter.products[indexPath.item]
        
        if let subscription = self.presenter.getSubscription(), cell.product?.productIdentifier == subscription {
            cell.isSelected = true
        }
        
        return cell
    }
    
}

extension SubscriptionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubscriptionCollectionViewCell else {
            return
        }
        
        for i in 0 ..< collectionView.visibleCells.count {
            if cell != collectionView.visibleCells[i] {
                collectionView.deselectItem(at: IndexPath(item: i, section: indexPath.section), animated: true)
            }
        }
        
        if self.presenter.products[indexPath.item].productIdentifier != self.presenter.getSubscription() {
            self.presenter.makePayment(self.presenter.products[indexPath.item]) { [ weak self ] error in
                guard let self = self, error == nil else {
                    return
                }
                
                self.presenter.makePayment(self.presenter.products[indexPath.item]) { self.error($0) }
            }
        }
    }
    
}

extension SubscriptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.contentSize.width - 25) / 2, height: (collectionView.contentSize.width - 25) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
}
