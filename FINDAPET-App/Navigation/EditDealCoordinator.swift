//
//  EditDealCoordinator.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 30.06.2023.
//

import Foundation
import UIKit

//MARK: - Edit Deal Coordinatable
protocol EditDealCoordinatable {
    var coordinatorDelegate: EditDealCoordinator? { get set }
}

//MARK: - Edit Deal Coordinator
final class EditDealCoordinator: Coordinator, MainTabBarCoordinatable {
    
//    MARK: - Properties
    var coordinatorDelegate: MainTabBarCoordinator?
    let navigationController = CustomNavigationController()
    
//    MARK: - Start
    func start() {
        self.setupViews()
        self.goToEditDeal()
    }
    
//    MARK: - Edit Deal
    func getEditDeal(deal: Deal.Input? = nil, isCreate: Bool = true) -> EditDealViewController {
        let router = EditDealRouter()
        let interactor = EditDealInteractor()
        let presenter = EditDealPresenter(router: router, interactor: interactor, deal: deal, isCreate: isCreate)
        let viewController = EditDealViewController(presenter: presenter)
        
        return viewController
    }
    
    func goToEditDeal(deal: Deal.Input? = nil, isCreate: Bool = true, animated: Bool = true) {
        self.navigationController.pushViewController(self.getEditDeal(deal: deal, isCreate: isCreate), animated: animated)
    }
    
//    MARK: - Setup Views
    private func setupViews() {
        self.navigationController.tabBarItem = .init(
            title: NSLocalizedString("Create deal", comment: .init()),
            image: .init(named: "paw.plus.deselected"),
            selectedImage: .init(named: "paw.plus.selected")
        )
    }
    
}
