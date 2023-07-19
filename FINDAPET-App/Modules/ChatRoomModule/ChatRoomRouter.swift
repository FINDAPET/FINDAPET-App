//
//  ChatRoomRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.11.2022.
//

import Foundation

final class ChatRoomRouter: ChatRoomCoordinatable {
    
    var coordinatorDelegate: ChatRoomCoordinator?
    
    func getProfile(userID: UUID? = nil) -> ProfileViewController? {
        self.coordinatorDelegate?.getProfile(userID: userID)
    }
    
    func getBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController? {
        self.coordinatorDelegate?.getBrowseImage(dataSource)
    }
    
}
