//
//  WebSocketSender.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 06.11.2022.
//

import Foundation

final class WebSocketSender {
    
    private let urlSesinonWebSocketTask: URLSessionWebSocketTask
    
    init(_ urlSesinonWebSocketTask: URLSessionWebSocketTask) {
        self.urlSesinonWebSocketTask = urlSesinonWebSocketTask
    }
    
    func send(model: Encodable, completionHandler: @escaping (Error?) -> Void) {
        do {
            let data = try JSONEncoder().encode(model)
            
            self.urlSesinonWebSocketTask.send(.data(data), completionHandler: completionHandler)
        } catch {
            print("❌ Error: \(error.localizedDescription)")
            
            completionHandler(error)
        }
    }
    
    func send(string: String, completionHandler: @escaping (Error?) -> Void) {
        self.urlSesinonWebSocketTask.send(.string(string), completionHandler: completionHandler)
    }
    
    func close() {
        self.urlSesinonWebSocketTask.cancel()
    }
    
}
