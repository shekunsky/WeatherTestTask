//
//  APIError.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

// MARK: APIError for error handling
enum APIError: Swift.Error {
    
    case clientRequestError(reason: String?)
    case clientInternalError(reason: String?)
    case serverInternalError(reason: String?)
    
    var title: String {
        return "Error"
    }
    
    var description: String {
        switch self {
        case let .clientRequestError(reason):
            return reason ?? "Unknown error!"
        case let .clientInternalError(reason):
            return reason ?? "Unknown error!"
        case let .serverInternalError(reason):
            return reason ?? "Internal server error, try again latter."
        }
    }
}
