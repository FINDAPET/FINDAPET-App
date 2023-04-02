//
//  WebSocketSender.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 06.11.2022.
//

import Foundation
import WebSocketKit
import Gzip

final class WebSocketSender {
    
//    MARK: - Properties
    var socket: WebSocket?
    
//    MARK: - Init
    init(socket: WebSocket? = nil) {
        self.socket = socket
    }
    
//    MARK: - Send Text
    func send(_ text: String) {
        self.socket?.send(text)
    }
    
//    MARK: - Send Data
    func send(_ data: Data) {
        print("\(#function) data size: \(data.count) bytes")
        
        self.socket?.send([UInt8](data))
    }
    
//    MARK: - Send Model
    func send(_ model: Encodable) {
        guard let data = (try? JSONEncoder().encode(model).gunzipped()) ?? (try? JSONEncoder().encode(model)) else {
            print("❌ Error: encoding failed.")
            
            return
        }
        
        print("\(#function) data size: \(data.count) bytes")
        
        self.socket?.send([UInt8](data))
    }
    
//    MARK: - Close
    func close(_ completionHandler: @escaping (Error?) -> Void) {
        self.socket?.close().whenComplete { result in
            switch result {
            case .success(_):
                completionHandler(nil)
            case .failure(let failure):
                print("❌ Error: \(failure.localizedDescription)")
                
                completionHandler(failure)
            }
        }
    }
    
}
