//
//  Task.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

import Moya

extension Task {
    
    static var defaultParameters: [String : Any] {
        return ["APPID" : ApiConstants.kApiKey, "units" : ApiConstants.kApiUnits]
    }
    
    static func requestDefaultParameters(configure: ((inout [String : Any]) -> Void), encoding: ParameterEncoding = URLEncoding.queryString) -> Task {
        return Task.requestParameters(parameters: {
            var parameters = defaultParameters
            configure(&parameters)
            return parameters
        }(), encoding: encoding)
    }
}
