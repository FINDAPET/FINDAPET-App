//
//  WebSocketSender.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 06.11.2022.
//

import Foundation
import Starscream
import Gzip

final class WebSocketSender {
    
//    MARK: - Properties
    var onBinaryAction: ((Data?, Error?) -> Void)?
    var onTextAction: ((String?, Error?) -> Void)?
    private let socket: WebSocket
    
//    MARK: - Init
    init(socket: WebSocket) {
        self.socket = socket
    }
    
//    MARK: - Send 1
    func send(_ text: String, completion: @escaping () -> Void = { }) {
        self.socket.write(string: text, completion: completion)
    }
    
//    MARK: - Send 2
    func send(_ data: Data, completion: @escaping () -> Void = { }) {
        self.socket.write(data: data, completion: completion)
    }
    
//    MARK: - Send 3
    func send(_ model: Encodable, completion: @escaping () -> Void = { }) {
        guard let data = (try? JSONEncoder().encode(model).gunzipped()) ?? (try? JSONEncoder().encode(model)) else {
            print("❌ Error: encoding failed.")
            
            return
        }
        
        self.socket.write(data: data, completion: completion)
    }
    
//    MARK: - Close
    func close() {
        self.socket.disconnect()
    }
    
}

//MARK: - Extensions
extension WebSocketSender: WebSocketDelegate {
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        switch event {
        case .connected(let headers):
            print("❕Websocket is connected: \(headers).")
        case .disconnected(let reason, let code):
            print("❕Websocket is disconnected: \(reason) with code: \(code).")
        case .text(let string):
            self.onTextAction?(string, nil)
        case .binary(let data):
            self.onBinaryAction?(data, nil)
        case .pong(_):
            break
        case .ping(_):
            break
        case .error(let error):
            guard let error else { return }
            
            self.onTextAction?(nil, error)
            self.onBinaryAction?(nil, error)
            
            print("❌ Error: \(error.localizedDescription)")
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            print("❕Websocket is cancelled.")
        }
    }
}
//@available(iOS 13.0, *)
//final class WebSocketSender {
//
////    MARK: - Properties
//    private let urlSesinonWebSocketTask: URLSessionWebSocketTask
//
////    MARK: - Init
//    init(_ urlSesinonWebSocketTask: URLSessionWebSocketTask) {
//        self.urlSesinonWebSocketTask = urlSesinonWebSocketTask
//    }
//
////    MARK: - Send 2
//    func send(model: Encodable, completionHandler: @escaping (Error?) -> Void) {
//        do {
//            let data = try JSONEncoder().encode(model)
//
//            self.urlSesinonWebSocketTask.send(.data(data)) { error in
//                DispatchQueue.main.async { completionHandler(error) }
//            }
//        } catch {
//            print("❌ Error: \(error.localizedDescription)")
//
//            DispatchQueue.main.async { completionHandler(error) }
//        }
//    }
//
////    MARK: - Send 2
//    func send(string: String, completionHandler: @escaping (Error?) -> Void) {
//        self.urlSesinonWebSocketTask.send(.string(string)) { error in
//            DispatchQueue.main.async { completionHandler(error) }
//        }
//    }
//
////    MARK: - Close
//    func close() {
//        self.urlSesinonWebSocketTask.cancel()
//    }
//
//}
