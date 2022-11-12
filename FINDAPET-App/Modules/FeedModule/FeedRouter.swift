//
//  FeedRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 11.11.2022.
//

import Foundation

final class FeedRouter: FeedCoordinatable {
    
    var coordinatorDelegate: FeedCoordinator?
    
    func goToDeal(dealID: UUID? = nil, deal: Deal.Output? = nil) {
        self.coordinatorDelegate?.goToDeal(dealID: dealID, deal: deal)
    }
    
}
