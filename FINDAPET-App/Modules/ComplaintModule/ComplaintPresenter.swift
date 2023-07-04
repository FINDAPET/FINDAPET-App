//
//  ComplaintPresenter.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.12.2022.
//

import Foundation

final class ComplaintPresenter {
    
    private(set) var complaint: Complaint.Input
    private let router: ComplaintRouter
    private let interactor: ComplaintInteractor
    
    init(complaint: Complaint.Input, router: ComplaintRouter, interactor: ComplaintInteractor) {
        self.complaint = complaint
        self.router = router
        self.interactor = interactor
    }
    
//    MARK: Requests
    func makeComplaint(completionHandler: @escaping (Error?) -> Void = { _ in }) {
        self.interactor.makeComplaint(self.complaint, completionHandler: completionHandler)
    }
    
//    MARK: Editing
    func editText(_ text: String) {
        self.complaint.text = text
    }
    
}
