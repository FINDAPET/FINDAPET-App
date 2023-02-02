//
//  ChatRoomRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

final class ChatRoomRouter: ChatRoomCoordinatable {
    
    var coordinatorDelegate: ChatRoomCoordinator?
    
    func goToProfile(userID: UUID? = nil) {
        self.coordinatorDelegate?.goToProfile(userID: userID)
    }
    
    func getBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController? {
        self.coordinatorDelegate?.getBrowseImage(dataSource)
    }
    
}
