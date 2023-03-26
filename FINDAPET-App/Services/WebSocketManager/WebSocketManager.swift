//
//  WebSocketManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import Starscream

final class WebSocketManager {

//    MARK: Request 1
    static func webSocket(
        url: URL,
        authMode: WSAuthentaficationMode? = nil,
        completionHandler: @escaping (String?, Error?) -> Void
    ) -> WebSocketSender {
        var req = URLRequest(url: url)

        req.setValue(Headers.applicationJson.rawValue, forHTTPHeaderField: Headers.contentType.rawValue)
        req.addValue(Headers.gzip.rawValue, forHTTPHeaderField: Headers.contentEncoding.rawValue)
        req.setValue(.init(format: "%lu", UInt.max), forHTTPHeaderField: Headers.contentLenght.rawValue)
                
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

        let socket = WebSocket(request: req, compressionHandler: WSCompression())
        let sender = WebSocketSender(socket: socket)

        sender.onTextAction = completionHandler
        socket.delegate = sender
        socket.connect()

        return sender
    }

//    MARK: Request 2
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
        
        var socket: WebSocket!
        
        if #available(iOS 13.0, *) {
            socket = WebSocket(request: req, engine: NativeEngine())
        } else {
            socket = WebSocket(
                request: req,
                engine: WSEngine(transport: TCPTransport(), compressionHandler: WSCompression())
            )
        }
        
        let sender = WebSocketSender(socket: socket)

        sender.onBinaryAction = completionHandler
        socket.delegate = sender
        socket.connect()

        return sender
    }

}
