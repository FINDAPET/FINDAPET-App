//
//  ApplicationRequestManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 15.10.2022.
//

import Foundation
import UIKit

final class ApplicationRequestManager {
    
    static func request(_ url: URL, model: Encodable? = nil, completionHandler: @escaping (Error?) -> Void = { _ in }) {
        var request = URLRequest(url: url)
        
        if let model = model {
            request.httpBody = try? JSONEncoder().encode(model)
        }
        
        guard let url = request.url else {
            print("❌ Error: url is equal to nil.")
            
            completionHandler(ApplicationRequestErrors.urlIsEqualtToNil)
            
            return
        }
        
        UIApplication.shared.open(url) { success in
            if success {
                completionHandler(nil)
                
                return
            } else {
                print("❌ Error: open url failed.")
                
                completionHandler(ApplicationRequestErrors.openURLFailed)
                
                return
            }
        }
    }
    
}
