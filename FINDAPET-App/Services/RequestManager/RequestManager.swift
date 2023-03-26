//
//  DataManager.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation
import Gzip

final class RequestManager {
    
    // MARK: 1
    static func request<T : Decodable>(
        method: HTTPMethods,
        authMode: HTTPAuthentaficationMode? = nil,
        url: URL,
        completionHandler: @escaping (T?, Error?) -> Void
    ) {
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
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
        
        URLSession.shared.dataTask(with: req) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                
                return
            }
            
            if let httpURLResponse = response as? HTTPURLResponse {
                guard httpURLResponse.statusCode == 200 else {
                    print("❌ Error: status code is equal to \(httpURLResponse.statusCode)")
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, RequestErrors.statusCodeError(statusCode: httpURLResponse.statusCode))
                    }
                    
                    return
                }
                
                guard let data = (try? data?.gunzipped()) ?? data else {
                    print("❌ Error: data is equal to nil.")
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, RequestErrors.dataIsEqualToNil)
                    }
                    
                    return
                }
                
                guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                    print("❌ Error: decoding failed.")
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, RequestErrors.decodingFailed)
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    completionHandler(model, nil)
                }
            } else {
                print("❌ Error: response is equal to nil.")
                
                DispatchQueue.main.async {
                    completionHandler(nil, RequestErrors.responseIsEqualToNil)
                }
                
                return
            }
        }
        .resume()
    }
    
    // MARK: 2
    static func request<T1 : Encodable, T2 : Decodable>(
        sendModel: T1,
        method: HTTPMethods,
        authMode: HTTPAuthentaficationMode? = nil,
        url: URL,
        completionHandler: @escaping (T2?, Error?) -> Void
    ) {
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
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
        
        if let sendData = (try? JSONEncoder().encode(sendModel).gzipped()) ?? (try? JSONEncoder().encode(sendModel)) {
            req.setValue(.init(format: "%lu", UInt(sendData.count)), forHTTPHeaderField: Headers.contentLenght.rawValue)
            req.httpBody = sendData
            
            URLSession.shared.dataTask(with: req) { data, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                    
                    return
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    guard httpURLResponse.statusCode == 200 else {
                        print("❌ Error: status code is equal to \(httpURLResponse.statusCode)")
                        
                        DispatchQueue.main.async {
                            completionHandler(nil, RequestErrors.statusCodeError(statusCode:httpURLResponse.statusCode))
                        }
                        
                        return
                    }
                    
                    guard let data = (try? data?.gunzipped()) ?? data else {
                        print("❌ Error: data is equal to nil.")
                        
                        DispatchQueue.main.async {
                            completionHandler(nil, RequestErrors.dataIsEqualToNil)
                        }
                        
                        return
                    }
                    
                    guard let model = try? JSONDecoder().decode(T2.self, from: data) else {
                        print("❌ Error: decoding failed.")
                        
                        DispatchQueue.main.async {
                            completionHandler(nil, RequestErrors.decodingFailed)
                        }
                        
                        return
                    }
                    
                    DispatchQueue.main.async {
                        completionHandler(model, nil)
                    }
                } else {
                    print("❌ Error: response is equal to nil.")
                    
                    DispatchQueue.main.async {
                        completionHandler(nil, RequestErrors.responseIsEqualToNil)
                    }
                    
                    return
                }
            }
            .resume()
        } else {
            print("❌ Error: encoding failed.")
            
            completionHandler(nil, RequestErrors.encodingFailed)
            
            return
        }
    }
    
    // MARK: 3
    static func request<T : Encodable>(
        model: T,
        method: HTTPMethods,
        authMode: HTTPAuthentaficationMode? = nil,
        url: URL,
        completionHandler: @escaping (Error?) -> Void
    ) {
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
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
        
        if let data = (try? JSONEncoder().encode(model).gzipped()) ?? (try? JSONEncoder().encode(model)) {
            req.setValue(.init(format: "%lu", UInt(data.count)), forHTTPHeaderField: Headers.contentLenght.rawValue)
            req.httpBody = data
            
            URLSession.shared.dataTask(with: req) { _, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    
                    DispatchQueue.main.async {
                        completionHandler(error)
                    }
                    
                    return
                }
                
                if let httpURLResponse = response as? HTTPURLResponse {
                    guard httpURLResponse.statusCode == 200 else {
                        print("❌ Error: status code is equal to \(httpURLResponse.statusCode)")
                        
                        DispatchQueue.main.async {
                            completionHandler(RequestErrors.statusCodeError(statusCode:
                                                                                httpURLResponse.statusCode))
                        }
                        return
                    }
                    
                        DispatchQueue.main.async {
                            completionHandler(nil)
                        }
                    
                } else {
                    print("❌ Error: response is equal to nil.")
                    
                    DispatchQueue.main.async {
                        completionHandler(RequestErrors.responseIsEqualToNil)
                    }
                    
                    return
                }
            }
            .resume()
        } else {
            print("❌ Error: encoding failed.")
            
            completionHandler(RequestErrors.encodingFailed)
            
            return
        }
    }
    
    // MARK: 4
    static func request(
        method: HTTPMethods,
        authMode: HTTPAuthentaficationMode? = nil,
        url: URL,
        completionHandler: @escaping (Error?) -> Void
    ) {
        var req = URLRequest(url: url)
        
        req.httpMethod = method.rawValue
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
        
        URLSession.shared.dataTask(with: req) { _, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    completionHandler(error)
                }
                
                return
            }
            
            if let httpURLResponse = response as? HTTPURLResponse {
                guard httpURLResponse.statusCode == 200 else {
                    print("❌ Error: status code is equal to \(httpURLResponse.statusCode)")
                    
                    DispatchQueue.main.async {
                        completionHandler(RequestErrors.statusCodeError(statusCode: httpURLResponse.statusCode))
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
                
            } else {
                print("❌ Error: response is equal to nil.")
                
                completionHandler(RequestErrors.responseIsEqualToNil)
                
                return
            }
        }
        .resume()
    }
    
    
}
