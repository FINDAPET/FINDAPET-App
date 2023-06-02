//
//  FeedPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation
import UIKit

final class FeedPresenter {
    
    var callBack: (() -> Void)?
    private let router: FeedRouter
    private let interactor: FeedInteractor
    
    init(router: FeedRouter, interactor: FeedInteractor) {
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Properties
    private(set) var filter = Filter()
    private(set) var deals = [Deal.Output]() {
        didSet {            
            self.filter.checkedIDs = self.deals.map(\.id).filter { $0 != nil } as? [UUID] ?? .init()
            self.callBack?()
        }
    }
    private(set) var ad: Ad.Output? {
        didSet {
            self.callBack?()
        }
    }
    
//    MARK: Editing
    func setFilterTitle(_ title: String) {
        self.filter.title = title
    }
    
    func setFilterCheckedIDs(_ checkedIDs: [UUID] = .init()) {
        self.filter.checkedIDs = checkedIDs
    }
    
    func deleteFilter() {
        self.filter = .init(title: self.filter.title)
    }
    
    func fullFilterDelete() {
        self.filter = .init()
    }
    
    func makeDealsEmpty() {
        self.deals = .init()
    }
    
    func sortDeals() {
        self.deals = .init(Set(self.deals)).sorted { $0.score > $1.score }
    }
    
//    MARK: Notification Center
    func notificationCenterManagerAddObserver(
        _ observer: Any,
        name: NotificationCenterManagerKeys,
        additional parameter: String? = nil,
        action: Selector
    ) {
        self.interactor.notificationCenterManagerAddObserver(observer, name: name, additional: parameter, action: action)
    }
    
//    MARK: Requests
    func getDeals(isDealsSortable: Bool = false, _ completionHandler: @escaping ([Deal.Output]?, Error?) -> Void) {
        let newCompletionHandler: ([Deal.Output]?, Error?) -> Void = { [ weak self ] deals, error in
            completionHandler(deals?.filter(\.isActive).sorted { $0.score > $1.score }, error)
            
            guard error == nil else { return }
            
            self?.deals += .init(Set(deals ?? .init())).filter(\.isActive).sorted { $0.score > $1.score }
        }
        
        self.interactor.getDeals(self.filter, completionHandler: newCompletionHandler)
    }
    
    func getRandomAd(completionHandler: @escaping (Ad.Output?, Error?) -> Void = { _, _ in }) {
        let newCompletionHandler: (Ad.Output?, Error?) -> Void = { [ weak self ] ad, error in
            completionHandler(ad, error)
            
            guard error == nil else {
                return
            }
            
            self?.ad = ad
        }
        
        self.interactor.getRandomAd(completionHandler: newCompletionHandler)
    }
    
//    MARK: Aplication Requests
    func goToUrl() {
        if #available(iOS 16.0, *) {
            self.interactor.goTo(url: .init(string: self.ad?.link ?? .init()) ?? .init(filePath: .init()))
        } else {
            self.interactor.goTo(url: .init(string: self.ad?.link ?? .init()) ?? .init(fileURLWithPath: .init()))
        }
    }
    
//    MARK: Routing
    func goToDeal(deal: Deal.Output) {
        self.router.goToDeal(deal: deal)
    }
    
    func goToProfile() {
        self.router.goToProfile(userID: self.ad?.cattery?.id)
    }
    
    func goToSearch(_ onTapSearchButtonAction: @escaping (String) -> Void) {
        self.router.goToSearch(with: self.filter.title, onTapSearchButtonAction)
    }
    
    func getFilter(
        startHandler: @escaping () -> Void = { },
        completionHandler: @escaping ([Deal.Output]?, Error?) -> Void
    ) -> FilterViewController? {
        self.router.getFilter(filter: self.filter) { [ weak self ] filter in
            startHandler()
            
            self?.filter = filter
            self?.makeDealsEmpty()
            self?.setFilterCheckedIDs()
            self?.getDeals(completionHandler)
            self?.getRandomAd()
        }
    }
    
}
