//
//  Handler.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import Result
import Moya

protocol Handler {
    
}

extension Handler {
    
    static func handle(result: APIResult, onSuccess: ((Response) -> Void)? = nil, onError: ((APIError) -> Void)? = nil) {
        switch result {
        case let .failure(error):
            onError?(error)
        case let .success(response):
            onSuccess?(response)
        }
    }
}
