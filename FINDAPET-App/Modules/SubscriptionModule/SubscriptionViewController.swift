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
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(SubscriptionCollectionViewCell.self, forCellWithReuseIdentifier: SubscriptionCollectionViewCell.cellID)
        view.register(
            SubscriptionHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SubscriptionHeaderCollectionReusableView.id
        )
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
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
        self.navigationController?.navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
        self.title = NSLocalizedString("Subscription", comment: String())
                
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(15)
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
                
                self.presenter.makePayment(self.presenter.products[indexPath.item]) {
                    self.error($0) {
                        guard let id = ProductsID.getProductID(rawValue: self.presenter.products[indexPath.item].productIdentifier) else {
                            print("❌ Error: product is equal to nil.")
                            
                            self.presentAlert(title: NSLocalizedString("Error", comment: String()))
                            
                            return
                        }
                        
                        self.presenter.makeUserPremium(Subscription(productID: id)) { error in
                            self.error(error) {
                                switch id {
                                case .premiumSubscriptionOneMonth:
                                    self.presenter.setPremiumUserDate(Calendar.current.nextDate(
                                        after: .init(),
                                        matching: .init(month: 1),
                                        matchingPolicy: .previousTimePreservingSmallerComponents
                                    ) ?? .init())
                                case .premiumSubscriptionThreeMonth:
                                    self.presenter.setPremiumUserDate(Calendar.current.nextDate(
                                        after: .init(),
                                        matching: .init(month: 3),
                                        matchingPolicy: .previousTimePreservingSmallerComponents
                                    ) ?? .init())
                                case .premiumSubscriptionSixMonth:
                                    self.presenter.setPremiumUserDate(Calendar.current.nextDate(
                                        after: .init(),
                                        matching: .init(month: 6),
                                        matchingPolicy: .previousTimePreservingSmallerComponents
                                    ) ?? .init())
                                case .premiumSubscriptionOneYear:
                                    self.presenter.setPremiumUserDate(Calendar.current.nextDate(
                                        after: .init(),
                                        matching: .init(year: 1),
                                        matchingPolicy: .previousTimePreservingSmallerComponents
                                    ) ?? .init())
                                default:
                                    self.presentAlert(title: NSLocalizedString("Error", comment: .init()))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SubscriptionHeaderCollectionReusableView.id,
            for: indexPath
        )
    }
        
}

extension SubscriptionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 202)
    }
    
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
