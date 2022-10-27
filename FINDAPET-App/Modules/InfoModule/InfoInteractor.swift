//
//  InfoInteractor.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 27.10.2022.
//

import Foundation

final class InfoInteractor {
    
//    MARK: Application Requests
    func applicationGo(to url: URL) {
        ApplicationRequestManager.request(url)
    }
    
}
