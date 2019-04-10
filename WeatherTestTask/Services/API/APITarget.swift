//
//  APITarget.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Moya
import Foundation

protocol APITarget: TargetType {
    
}

extension APITarget {
    
    var baseURL: URL {
        return URL(string: ApiConstants.kApiBaseURL)!
    }
    
    var method: Moya.Method {
        return .post
    }

    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["accept" : "application/json"]
    }
}
