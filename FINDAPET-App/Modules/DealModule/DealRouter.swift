//
//  DealRouter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.10.2022.
//

import Foundation

final class DealRouter: ProfileCoordinatable {
    
    var coordinatorDelegate: ProfileCoordinator?
    
    func getProfile(with id: UUID? = nil) -> ProfileViewController? {
        self.coordinatorDelegate?.getProfile(userID: id)
    }
    
    func getChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) -> ChatRoomViewController? {
        self.coordinatorDelegate?.getChatRoom(chatRoom: chatRoom, userID: userID)
    }
    
    func getCreateOffer(deal: Deal.Output) -> CreateOfferViewController? {
        self.coordinatorDelegate?.getCreateOffer(deal: deal)
    }
    
    func getComplaint(_ complaint: Complaint.Input) -> ComplaintViewController? {
        self.coordinatorDelegate?.getComplaint(complaint)
    }
    
    func getBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController? {
        self.coordinatorDelegate?.getBrowseImage(dataSource)
    }
    
    func getEditDeal(_ deal: Deal.Input, isCreate: Bool = true) -> EditDealViewController? {
        self.coordinatorDelegate?.getEditDeal(deal, isCreate: isCreate)
    }
    
}
