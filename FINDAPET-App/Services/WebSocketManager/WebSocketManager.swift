//
//  WebSocketManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

final class WebSocketManager {
    
    static func webSocket(
        url: URL,
        authMode: WSAuthentaficationMode?,
        completionHandler: @escaping (String?, Error?) -> Void
    ) {
        var req = URLRequest(url: url)
        let configuration = URLSessionConfiguration.background(withIdentifier: Bundle.main.bundleIdentifier ?? "com.artemiy.FINDAPET-App")
        
        req.setValue(Headers.applicationJson.rawValue, forHTTPHeaderField: Headers.contentType.rawValue)
        
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true
        configuration.allowsCellularAccess = true
        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.waitsForConnectivity = true
        
        if let authMode = authMode {
            switch authMode {
            case .base(let email, let password):
                req.setValue(
                    Headers.authString(email: email, password: password),
                    forHTTPHeaderField: Headers.authorization.rawValue
                )
            case .bearer(let value):
                req.setValue(
                    Headers.bearerAuthString(token: value),
                    forHTTPHeaderField: Headers.authorization.rawValue
                )
            }
        }
        
        let webSocketTask = URLSession(configuration: configuration).webSocketTask(with: req)
        
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let string):
                    completionHandler(string, nil)
                default:
                    break
                }
                
                webSocketTask.cancel()
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                
                completionHandler(nil, error)
                
                webSocketTask.cancel()
                
                return
            }
        }
        
        webSocketTask.resume()
    }
    
    static func webSocket(
        url: URL,
        authMode: WSAuthentaficationMode?,
        completionHandler: @escaping (Data?, Error?) -> Void
    ) {
        var req = URLRequest(url: url)
        let configuration = URLSessionConfiguration.background(withIdentifier: Bundle.main.bundleIdentifier ?? "com.artemiy.FINDAPET-App")
        
        req.setValue(Headers.applicationJson.rawValue, forHTTPHeaderField: Headers.contentType.rawValue)
        
        configuration.sessionSendsLaunchEvents = true
        configuration.isDiscretionary = true
        configuration.allowsCellularAccess = true
        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.waitsForConnectivity = true
        
        if let authMode = authMode {
            switch authMode {
            case .base(let email, let password):
                req.setValue(
                    Headers.authString(email: email, password: password),
                    forHTTPHeaderField: Headers.authorization.rawValue
                )
            case .bearer(let value):
                req.setValue(
                    Headers.bearerAuthString(token: value),
                    forHTTPHeaderField: Headers.authorization.rawValue
                )
            }
        }
        
        let webSocketTask = URLSession(configuration: configuration).webSocketTask(with: req)
        
        webSocketTask.receive { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    completionHandler(data, nil)
                default:
                    break
                }
                
                webSocketTask.cancel()
            case .failure(let error):
                print("❌ Error: \(error.localizedDescription)")
                
                completionHandler(nil, error)
                
                webSocketTask.cancel()
                
                return
            }
        }
        
        webSocketTask.resume()
    }
    
}
