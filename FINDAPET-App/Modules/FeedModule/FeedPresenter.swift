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
    private var filter = Filter()
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
        self.filter = Filter(title: self.filter.title)
    }
    
//    MARK: Requests
    func getDeals(completionHandler: @escaping ([Deal.Output]?, Error?) -> Void) {
        let newCompletionHandler: ([Deal.Output]?, Error?) -> Void = { [ weak self ] deals, error in
            completionHandler(deals?.sorted { $0.score > $1.score }, error)
            
            guard error == nil else {
                return
            }
            
            self?.deals += deals?.sorted { $0.score > $1.score } ?? .init()
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
        self.interactor.goTo(url: URL(string: self.ad?.link ?? .init()) ?? .init(fileURLWithPath: .init()))
    }
    
//    MARK: Routing
    func goToDeal(deal: Deal.Output) {
        self.router.goToDeal(deal: deal)
    }
    
    func goToProfile() {
        self.router.goToProfile(userID: self.ad?.cattery?.id)
    }
    
    func getFilter(completionHandler: @escaping ([Deal.Output]?, Error?) -> Void) -> FilterViewController? {
        self.router.getFilter(filter: self.filter) { filter in
            self.filter = filter
            
            self.setFilterCheckedIDs()
            self.getDeals(completionHandler: completionHandler)
            self.getRandomAd()
        }
    }
    
}
