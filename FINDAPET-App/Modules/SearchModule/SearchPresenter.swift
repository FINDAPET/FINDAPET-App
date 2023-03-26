//
//  SearchPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 14.03.2023.
//

import Foundation

final class SearchPresenter {
    
//    MARK: Init Properties
    var callBack: (() -> Void)?
    let onTapSearchButtonAction: (String) -> Void
    let title: String?
    private let router: SearchRouter
    private let interactor: SearchInteractor
    
//    MARK: Init
    init(
        router: SearchRouter,
        interactor: SearchInteractor,
        title: String?,
        onTapSearchButtonAction: @escaping (String) -> Void
    ) {
        self.router = router
        self.interactor = interactor
        self.title = title
        self.onTapSearchButtonAction = onTapSearchButtonAction
    }
    
//    MARK: Propeties
    private(set) var titles = [SearchTitle.Output]() {
        didSet {
            self.callBack?()
        }
    }
    
//    MARK: Requests
    func getAll(_ completionHandler: @escaping ([SearchTitle.Output]?, Error?) -> Void = { _, _ in }) {
        let newCompletionHandler: ([SearchTitle.Output]?, Error?) -> Void = { [ weak self ] titles, error in
            completionHandler(titles, error)
            
            guard error == nil, let titles = titles else {
                return
            }
            
            self?.titles = titles
        }
        
        self.interactor.getAll(newCompletionHandler)
    }
    
    func create(_ title: String, completionHandler: @escaping (Error?) -> Void = { _ in }) {
        guard let id = self.getUserID() else {
            completionHandler(RequestErrors.statusCodeError(statusCode: 404))
            
            return
        }
        
        self.interactor.create(.init(title: title, userID: id), completionHandler: completionHandler)
    }
    
//    MARK: User Defaults
    func getUserID() -> UUID? {
        guard let string = self.interactor.getUserDefaults(with: .id) as? String else {
            return nil
        }
        
        return .init(uuidString: string)
    }
    
}
