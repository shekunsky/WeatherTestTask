//
//  APIWeather.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import Moya

enum APIWeather {

    case getWeatherWithCoordinates(lon: Double, lat: Double)
    case getWeatherWithGroup(group: [String])
    case getWeatherForecastWithId(id: Int)
    
}

extension APIWeather: APITarget {
    
    var path: String {
        switch self {
        case .getWeatherWithCoordinates:
            return "weather"
        case .getWeatherWithGroup:
            return "group"
        case .getWeatherForecastWithId:
            return "forecast"
        }
    }
    
    var task: Task {
        switch self {
        case let .getWeatherWithCoordinates(lon, lat):
            return Task.requestDefaultParameters(configure: { (parameters) in
                parameters["lon"] = lon
                parameters["lat"] = lat
            })
        case let .getWeatherWithGroup(group):
            return Task.requestDefaultParameters(configure: { (parameters) in
                parameters["id"] = group.joined(separator: ",")
            })
        case let .getWeatherForecastWithId(id):
            return Task.requestDefaultParameters(configure: { (parameters) in
                parameters["id"] = id
            })
        }
    }
}
