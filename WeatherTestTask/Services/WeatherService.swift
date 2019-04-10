//
//  WeatherService.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

class WeatherService: Handler {
        
    class func getWeatherWithGroup(group: [String], completion: @escaping ((ListOfWeatherStruct?, Error?) -> Void)) {
        APIManager.weather.request(.getWeatherWithGroup(group: group)) { (result) in
            self.handle(result: result, onSuccess: { (response) in
                if let weather = try? response.map(ListOfWeatherStruct.self) {
                    DispatchQueue.main.async {
                        completion(weather, nil)
                    }
                }
            }, onError: { (error) in
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            })
        }
    }
    
    class func getWeatherForecastWithId(id: Int, completion: @escaping ((ListForecastWeatherStruct?, Error?) -> Void)) {
        APIManager.weather.request(.getWeatherForecastWithId(id: id)) { (result) in
            self.handle(result: result, onSuccess: { (response) in
                if let weather = try? response.map(ListForecastWeatherStruct.self) {
                    DispatchQueue.main.async {
                        completion(weather, nil)
                    }
                }
            }, onError: { (error) in
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            })
        }
    }
    
    class func getWeatherWithCoordinates(lon: Double, lat: Double, completion: @escaping ((Weather?, Error?) -> Void)) {
        APIManager.weather.request(.getWeatherWithCoordinates(lon: lon, lat: lat)) { (result) in
            self.handle(result: result, onSuccess: { (response) in
                if let weather = try? response.map(Weather.self) {
                    DispatchQueue.main.async {
                        completion(weather, nil)
                    }
                }
            }, onError: { (error) in
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            })
        }
    }
}
