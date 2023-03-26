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
    
    private lazy var subscriptionInformationView: SubscriptionInformationView? = {
        let view = self.presenter.getSubscriptionInforamation()
        
        view?.setupValues()
        view?.alpha = self.presenter.getSubscription() == nil ? .zero : 1
        view?.isHidden = self.presenter.getSubscription() == nil
        view?.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
//    MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.getSubscriptionsProducts()
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
        
        guard let subscriptionInformationView = self.subscriptionInformationView else {
            return
        }
        
        self.view.addSubview(subscriptionInformationView)
        self.view.insertSubview(subscriptionInformationView, at: 10)
        
        subscriptionInformationView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        if self.presenter.getSubscription() != nil {
            self.navigationController?.navigationBar.isHidden = true
            self.collectionView.isHidden = true
            subscriptionInformationView.isHidden = false
            subscriptionInformationView.alpha = 1
            subscriptionInformationView.setupValues()
        }
    }

}

extension SubscriptionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SubscriptionCollectionViewCell.cellID,
            for: indexPath
        ) as? SubscriptionCollectionViewCell else {
            return .init()
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
        if let subscription = self.presenter.getSubscription(),
           let cell = collectionView.cellForItem(at: indexPath) as? SubscriptionCollectionViewCell,
           cell.product?.productIdentifier != subscription {
            collectionView.deselectItem(at: indexPath, animated: false)
            
            for i in .zero ..< collectionView.visibleCells.count {
                guard let subCell = collectionView.visibleCells[i] as? SubscriptionCollectionViewCell,
                      subCell.product?.productIdentifier == subscription else {
                    collectionView.selectItem(
                        at: .init(item: i, section: .zero),
                        animated: false,
                        scrollPosition: .centeredHorizontally
                    )
                    
                    continue
                }
            }
            
            return
        }
        
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
                            collectionView.deselectItem(at: indexPath, animated: true)
                            
                            return
                        }
                        
                        self.presenter.makePayment(self.presenter.products[indexPath.item]) {
                            self.error($0) {
                                guard let id = ProductsID.getProductID(rawValue: self.presenter.products[indexPath.item].productIdentifier) else {
                                    print("❌ Error: product is equal to nil.")
                                    
                                    collectionView.deselectItem(at: indexPath, animated: true)
                                    self.presentAlert(title: NSLocalizedString("Error", comment: String()))
                                    
                                    return
                                }
                                
                                self.presenter.makeUserPremium(Subscription(productID: id)) { error in
                                    self.error(error) {
                                        switch id {
                                        case .premiumSubscriptionOneMonth:
                                            self.presenter.setSubscription(id)
                                            self.presenter.setPremiumUserDate({
                                                var compenents = Calendar.current.dateComponents(
                                                    [.day, .month, .hour, .year],
                                                    from: .init()
                                                )
                                                
                                                compenents.month = (compenents.month ?? .zero) + 1
                                                
                                                return Calendar.current.date(from: compenents) ?? .init()
                                            }())
                                            self.presenter.reloadProfileScreen()
                                            self.subscriptionInformationView?.setupValues()
                                            self.subscriptionInformationView?.alpha = .zero
                                            
                                            UIView.animate(withDuration: 0.25) {
                                                self.collectionView.alpha = .zero
                                                self.view.backgroundColor = .accentColor
                                                self.navigationController?.navigationBar.alpha = .zero
                                            } completion: { completed in
                                                self.navigationController?.navigationBar.isHidden = true
                                                self.collectionView.isHidden = true
                                                self.subscriptionInformationView?.isHidden = false
                                                
                                                UIView.animate(withDuration: 0.25) {
                                                    self.subscriptionInformationView?.alpha = 1
                                                }
                                            }
                                        case .premiumSubscriptionThreeMonth:
                                            self.presenter.setSubscription(id)
                                            self.presenter.setPremiumUserDate({
                                                var compenents = Calendar.current.dateComponents(
                                                    [.day, .month, .hour, .year],
                                                    from: .init()
                                                )
                                                
                                                compenents.month = (compenents.month ?? .zero) + 3
                                                
                                                return Calendar.current.date(from: compenents) ?? .init()
                                            }())
                                            self.presenter.reloadProfileScreen()
                                            self.subscriptionInformationView?.setupValues()
                                            self.subscriptionInformationView?.alpha = .zero
                                            
                                            UIView.animate(withDuration: 0.25) {
                                                self.collectionView.alpha = .zero
                                                self.view.backgroundColor = .accentColor
                                                self.navigationController?.navigationBar.alpha = .zero
                                            } completion: { completed in
                                                self.navigationController?.navigationBar.isHidden = true
                                                self.collectionView.isHidden = true
                                                self.subscriptionInformationView?.isHidden = false
                                                
                                                UIView.animate(withDuration: 0.25) {
                                                    self.subscriptionInformationView?.alpha = 1
                                                }
                                            }
                                        case .premiumSubscriptionSixMonth:
                                            self.presenter.setSubscription(id)
                                            self.presenter.setPremiumUserDate({
                                                var compenents = Calendar.current.dateComponents(
                                                    [.day, .month, .hour, .year],
                                                    from: .init()
                                                )
                                                
                                                compenents.month = (compenents.month ?? .zero) + 6
                                                
                                                return Calendar.current.date(from: compenents) ?? .init()
                                            }())
                                            self.presenter.reloadProfileScreen()
                                            self.subscriptionInformationView?.setupValues()
                                            self.subscriptionInformationView?.alpha = .zero
                                            
                                            UIView.animate(withDuration: 0.25) {
                                                self.collectionView.alpha = .zero
                                                self.view.backgroundColor = .accentColor
                                                self.navigationController?.navigationBar.alpha = .zero
                                            } completion: { completed in
                                                self.navigationController?.navigationBar.isHidden = true
                                                self.collectionView.isHidden = true
                                                self.subscriptionInformationView?.isHidden = false
                                                
                                                UIView.animate(withDuration: 0.25) {
                                                    self.subscriptionInformationView?.alpha = 1
                                                }
                                            }
                                        case .premiumSubscriptionOneYear:
                                            self.presenter.setSubscription(id)
                                            self.presenter.setPremiumUserDate({
                                                var compenents = Calendar.current.dateComponents(
                                                    [.day, .month, .hour, .year],
                                                    from: .init()
                                                )
                                                
                                                compenents.year = (compenents.year ?? .zero) + 1
                                                
                                                print(Calendar.current.date(from: compenents) as Any)
                                                
                                                return Calendar.current.date(from: compenents) ?? .init()
                                            }())
                                            self.presenter.reloadProfileScreen()
                                            self.subscriptionInformationView?.setupValues()
                                            self.subscriptionInformationView?.alpha = .zero
                                            
                                            UIView.animate(withDuration: 0.25) {
                                                self.collectionView.alpha = .zero
                                                self.view.backgroundColor = .accentColor
                                                self.navigationController?.navigationBar.alpha = .zero
                                            } completion: { completed in
                                                self.navigationController?.navigationBar.isHidden = true
                                                self.collectionView.isHidden = true
                                                self.subscriptionInformationView?.isHidden = false
                                                
                                                UIView.animate(withDuration: 0.25) {
                                                    self.subscriptionInformationView?.alpha = 1
                                                }
                                            }
                                        default:
                                            collectionView.deselectItem(at: indexPath, animated: true)
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
