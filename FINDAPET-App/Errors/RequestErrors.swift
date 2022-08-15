//
//  RequestErrors.swift
//  FINDAPET-App
//
//  Created by Artemiy Zuzin on 13.08.2022.
//

import Foundation

enum RequestErrors: Error {
    case decodingFailed, encodingFailed, dataIsEqualToNil, statrusCodeError(statusCode: Int), responseIsEqualToNil
}
