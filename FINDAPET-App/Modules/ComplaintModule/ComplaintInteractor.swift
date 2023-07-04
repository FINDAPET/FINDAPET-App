//
//  ComplaintInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 05.12.2022.
//

import Foundation

final class ComplaintInteractor {
    
//    MARK: Requests
    func makeComplaint(_ complaint: Complaint.Input, completionHandler: @escaping (Error?) -> Void) {
        RequestManager.request(
            model: complaint,
            method: .POST,
            authMode: .bearer(value: self.getBearrerToken() ?? .init()),
            url: URLConstructor.defaultHTTP.newCompaint(),
            completionHandler: completionHandler
        )
    }
    
//    MARK: Keychain
    private func getBearrerToken() -> String? {
        KeychainManager.shared.read(key: .token)
    }
    
}
