//
//  WebSocketManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import WebSocketKit
import NIOPosix
import NIOFoundationCompat
import NIOCore

final class WebSocketManager {
    
//    MARK: - Request Text
    static func webSocket(
        url: URL,
        authMode: WSAuthentaficationMode? = nil,
        completionHandler: @escaping (String?, Error?) -> Void
    ) -> WebSocketSender {
        var req = URLRequest(url: url)

        req.setValue(Headers.applicationJson.rawValue, forHTTPHeaderField: Headers.contentType.rawValue)
        req.addValue(Headers.gzip.rawValue, forHTTPHeaderField: Headers.contentEncoding.rawValue)
        
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
        
        var headers = [(String, String)]()
        
        for header in req.allHTTPHeaderFields ?? .init() {
            headers.append((header.key, header.value))
        }
        
        let sender = WebSocketSender()
        
        DispatchQueue.global(qos: .background).async {
            WebSocket.connect(
                to: url.absoluteString,
                headers: !headers.isEmpty ? .init(headers) : [:],
                configuration: .init(maxFrameSize: 1 << 24),
                on: MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
            ) { [ weak sender ] ws in
                print("❕NOTIFICATION: websocket connected.")
                
                sender?.socket = ws
                
                ws.onText { _, text in
                    print("❕NOTIFICATION: websocket get text: \(text)")
                    
                    completionHandler(text, nil)
                }
                
                ws.onBinary { _, _ in
                    print("❌ Error: websocket don't supported binary")
                }
            }.whenFailure { error in
                print("❌ Error: \(error.localizedDescription)")
                
                completionHandler(nil, error)
            }
        }
        
        return sender
    }
    
//    MARK: - Request Data
    static func webSocket(
        url: URL,
        authMode: WSAuthentaficationMode? = nil,
        completionHandler: @escaping (Data?, Error?) -> Void
    ) -> WebSocketSender {
        var req = URLRequest(url: url)

        req.setValue(Headers.applicationJson.rawValue, forHTTPHeaderField: Headers.contentType.rawValue)
        req.addValue(Headers.gzip.rawValue, forHTTPHeaderField: Headers.contentEncoding.rawValue)
        
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
        
        var headers = [(String, String)]()
        
        for header in req.allHTTPHeaderFields ?? .init() {
            headers.append((header.key, header.value))
        }
        
        let sender = WebSocketSender()
        
        DispatchQueue.global(qos: .background).async {
            WebSocket.connect(
                to: url.absoluteString,
                headers: !headers.isEmpty ? .init(headers) : [:],
                configuration: .init(maxFrameSize: 1 << 24),
                on: MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
            ) { [ weak sender ] ws in
                print("❕NOTIFICATION: websocket connected.")
                
                sender?.socket = ws
                
                ws.onText { _, _ in
                    print("❌ Error: websocket don't supported text")
                }
                
                ws.onBinary { ws, buffer in
                    print("❕NOTIFICATION: websocket get buffer: \(buffer)")
                    
                    completionHandler(.init(buffer: buffer), nil)
                }
            }.whenFailure { error in
                print("❌ Error: \(error.localizedDescription)")
                
                completionHandler(nil, error)
            }
        }
        
        return sender
    }
    
//    MARK: - Request Data and Text
    static func webSocket(
        url: URL,
        authMode: WSAuthentaficationMode? = nil,
        completionHandler: @escaping (Data?, String?, Error?) -> Void
    ) -> WebSocketSender {
        var req = URLRequest(url: url)

        req.setValue(Headers.applicationJson.rawValue, forHTTPHeaderField: Headers.contentType.rawValue)
        req.addValue(Headers.gzip.rawValue, forHTTPHeaderField: Headers.contentEncoding.rawValue)
        
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
        
        var headers = [(String, String)]()
        
        for header in req.allHTTPHeaderFields ?? .init() {
            headers.append((header.key, header.value))
        }
        
        let sender = WebSocketSender()
        
        DispatchQueue.global(qos: .background).async {
            WebSocket.connect(
                to: url.absoluteString,
                headers: !headers.isEmpty ? .init(headers) : [:],
                configuration: .init(maxFrameSize: 1 << 24),
                on: MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
            ) { [ weak sender ] ws in
                print("❕NOTIFICATION: websocket connected.")
                
                sender?.socket = ws
                
                ws.onText { _, text in
                    print("❕NOTIFICATION: websocket get text: \(text)")
                    
                    completionHandler(nil, text, nil)
                }
                
                ws.onBinary { _, buffer in
                    print("❕NOTIFICATION: websocket get buffer: \(buffer)")
                    
                    completionHandler(.init(buffer: buffer), nil, nil)
                }
            }.whenFailure { error in
                print("❌ Error: \(error.localizedDescription)")
                
                completionHandler(nil, nil, error)
            }
        }
        
        return sender
    }
    
}
