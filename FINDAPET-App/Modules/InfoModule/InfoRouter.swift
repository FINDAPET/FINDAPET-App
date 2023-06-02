//
//  InfoRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 27.10.2022.
//

import Foundation

final class InfoRouter: ProfileCoordinatable {
    
//    MARK: - Properties
    var coordinatorDelegate: ProfileCoordinator?
    
    
//    MARK: - Web View
    func goToWebView(_ url: URL) {
        self.coordinatorDelegate?.goToWebView(url)
    }
    
}
