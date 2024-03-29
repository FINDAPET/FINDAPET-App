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
        
        self.presenter.getSubscriptions { [ weak self ] _, error in
            self?.error(error)
        }
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
        self.presenter.subscriptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SubscriptionCollectionViewCell.cellID,
            for: indexPath
        ) as? SubscriptionCollectionViewCell else {
            return .init()
        }
        
        cell.subscription = self.presenter.subscriptions[indexPath.item]
        
        if let subscription = self.presenter.getSubscription(), cell.subscription?.id == subscription {
            cell.isSelected = true
        }
        
        return cell
    }
    
}

extension SubscriptionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let subscription = self.presenter.getSubscription(),
           let cell = collectionView.cellForItem(at: indexPath) as? SubscriptionCollectionViewCell,
           cell.subscription?.id != subscription {
            collectionView.deselectItem(at: indexPath, animated: false)
            
            for i in .zero ..< collectionView.visibleCells.count {
                guard let subCell = collectionView.visibleCells[i] as? SubscriptionCollectionViewCell,
                      subCell.subscription?.id == subscription else {
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
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? SubscriptionCollectionViewCell,
              let titleSubscriptionID = cell.subscription?.id,
              let userIDString = self.presenter.getUserID() else {
            return
        }
        
        for i in 0 ..< collectionView.visibleCells.count {
            if cell != collectionView.visibleCells[i] {
                collectionView.deselectItem(at: IndexPath(item: i, section: indexPath.section), animated: true)
            }
        }
        
        self.presenter.makeUserPremium(
            .init(
                titleSubscriptionID: titleSubscriptionID,
                expirationDate: .init().addingTimeInterval(.init(2_592_000 * (cell.subscription?.monthsCount ?? 1))),
                userID: .init(uuidString: userIDString)
            )) { [ weak self ] error in
                self?.error(error)
                self?.presenter.setSubscription(titleSubscriptionID)
                self?.presenter.reloadProfileScreen()
                self?.subscriptionInformationView?.setupValues()
                self?.subscriptionInformationView?.alpha = .zero
                self?.presenter.setPremiumUserDate(
                    .init().addingTimeInterval(.init(2_592_000 * (cell.subscription?.monthsCount ?? 1)))
                )
                
                UIView.animate(withDuration: 0.25) {
                    self?.collectionView.alpha = .zero
                    self?.view.backgroundColor = .accentColor
                    self?.navigationController?.navigationBar.alpha = .zero
                } completion: { completed in
                    self?.navigationController?.navigationBar.isHidden = true
                    self?.collectionView.isHidden = true
                    self?.subscriptionInformationView?.isHidden = false
                    
                    UIView.animate(withDuration: 0.25) {
                        self?.subscriptionInformationView?.alpha = 1
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
