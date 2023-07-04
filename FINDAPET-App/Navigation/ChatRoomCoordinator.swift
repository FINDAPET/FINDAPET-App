//
//  ChatRoomCoordinator.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.06.2023.
//

import Foundation
import UIKit

//MARK: - Chat Room Coordinatable
protocol ChatRoomCoordinatable {
    var coordinatorDelegate: ChatRoomCoordinator? { get set }
}

//MARK: - Chat Room Coordinator
final class ChatRoomCoordinator: Coordinator, MainTabBarCoordinatable {
    
//    MARK: - Properties
    var coordinatorDelegate: MainTabBarCoordinator?
    let navigationController = CustomNavigationController()
    
//    MARK: - Start
    func start() {
        self.setupViews()
        self.goToChatRooms()
    }
    
//    MARK: - Chat Rooms
    func getChatRooms() -> ChatRoomsViewController {
        let router = ChatRoomsRouter()
        let interactor = ChatRoomsInteractor()
        let presenter = ChatRoomsPresenter(router: router, interactor: interactor)
        let viewController = ChatRoomsViewController(presenter: presenter)
        
        router.coordinatorDelegate = self
        
        return viewController
    }
    
    func goToChatRooms(animated: Bool = true) {
        self.navigationController.pushViewController(self.getChatRooms(), animated: animated)
    }
    
//    MARK: - Chat Room
    func getChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil) -> ChatRoomViewController? {
        let router = ChatRoomRouter()
        let interactor = ChatRoomInteractor()
        
        router.coordinatorDelegate = self
        
        if let userID {
            let presenter = ChatRoomPresenter(userID: userID, router: router, interactor: interactor)
            let viewController = ChatRoomViewController(presenter: presenter)
            
            return viewController
        } else if let chatRoom {
            let presenter = ChatRoomPresenter(chatRoom: chatRoom, router: router, interactor: interactor)
            let viewController = ChatRoomViewController(presenter: presenter)
            
            return viewController
        }
        
        return nil
    }
    
    func goToChatRoom(chatRoom: ChatRoom.Output? = nil, userID: UUID? = nil, animated: Bool = true) {
        guard let viewController = self.getChatRoom(chatRoom: chatRoom, userID: userID) else { return }
        
        self.navigationController.pushViewController(viewController, animated: animated)
    }
    
//    MARK: - Profile
    func getProfile(userID: UUID? = nil) -> ProfileViewController? {
        self.coordinatorDelegate?.getProfile(userID: userID)
    }
    
    func goToProfile(userID: UUID? = nil, animated: Bool = true) {
        guard let viewController = self.getProfile(userID: userID) else { return }
        
        self.navigationController.pushViewController(viewController, animated: animated)
    }
    
//    MARK: - Browse Image
    func getBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) -> BrowseImagesViewController {
        let viewController = BrowseImagesViewController()
        
        viewController.dataSource = dataSource
        
        return viewController
    }
    
    func goToBrowseImage(_ dataSource: BrowseImagesViewControllerDataSource) {
        self.navigationController.pushViewController(self.getBrowseImage(dataSource), animated: true)
    }
    
//    MARK: - Setup Views
    private func setupViews() {
        self.navigationController.navigationBar.tintColor = .accentColor
        
        if #available(iOS 13.0, *) {
            self.navigationController.tabBarItem = .init(
                title: NSLocalizedString("Chats", comment: .init()),
                image: .init(systemName: "message"),
                selectedImage: .init(systemName: "message")
            )
        } else {
            self.navigationController.navigationBar.tintColor = .accentColor
            self.navigationController.tabBarItem = .init(
                title: NSLocalizedString("Chats", comment: .init()),
                image: .init(named: "message")?.withRenderingMode(.alwaysTemplate),
                selectedImage: .init(named: "message")?.withRenderingMode(.alwaysTemplate)
            )
        }
    }
    
}
