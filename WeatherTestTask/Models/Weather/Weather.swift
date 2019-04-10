//
//  Weather.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

protocol CommonWeatherProtocol {
    var date: Int {get set}
    var mainWeather: MainWeathertruct? {get set}
    var wind: WindStruct? {get set}
    var weather: [WeatherDataStruct]? {get set}
}

struct ListOfWeatherStruct: Codable {
    var list: [Weather]
    
}


struct ListForecastWeatherStruct: Codable {
    var list: [WeatherForecastStruct]
}

struct WindStruct: Codable {
    var speed: Double
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        speed = try container.decode(Double.self, forKey: .speed)
        
    }
    
    init (speed: Double) {
        self.speed = speed
    }
    
    enum CodingKeys: String, CodingKey {
        case speed
    }
}

struct WeatherDataStruct: Codable {
    var icon: String?
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.icon = try container.decode(String.self, forKey: .icon)
    }
    init(icon: String) {
        self.icon = icon
    }
    
    enum CodingKeys: String, CodingKey {
        case icon
    }
}

struct MainWeathertruct: Codable {
    var humidity: Int
    var tempMax: Double
    var tempMin: Double
    var temp: Double
    var pressure: Double
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.humidity = try container.decode(Int.self, forKey: .humidity)
        self.tempMax = try container.decode(Double.self, forKey: .tempMax)
        self.tempMin = try container.decode(Double.self, forKey: .tempMin)
        self.temp = try container.decode(Double.self, forKey: .temp)
        self.pressure = try container.decode(Double.self, forKey: .pressure)
    }
    init (humidity: Int, tempMax: Double, tempMin: Double, temp: Double, pressure: Double) {
        self.humidity = humidity
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.temp = temp
        self.pressure = pressure
    }
    
    enum CodingKeys: String, CodingKey {
        case humidity
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case temp
        case pressure
        
    }
}

struct WeatherForecastStruct: Codable, CommonWeatherProtocol {
    var currentDate: String
    var date: Int
    var mainWeather: MainWeathertruct?
    var wind: WindStruct?
    var weather: [WeatherDataStruct]?
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.currentDate = try container.decode(String.self, forKey: .currentDate)
        self.date = try container.decode(Int.self, forKey: .date)
        self.mainWeather = try container.decode(MainWeathertruct.self, forKey: .mainWeather)
        self.wind = try container.decode(WindStruct.self, forKey: .wind)
        self.weather = try container.decode([WeatherDataStruct].self, forKey: .weather)
    }
    
    init(currentDate: String, date: Int, wind: Double, humidity: Int, tempMax: Double, tempMin: Double, temp: Double, pressure: Double, icon: String) {
        
        self.currentDate = currentDate
        self.date = date
        self.wind = WindStruct(speed: wind)
        self.mainWeather = MainWeathertruct(humidity: humidity, tempMax: tempMax, tempMin: tempMin, temp: temp, pressure: pressure)
        self.weather = [WeatherDataStruct(icon: icon)]
    }
    
    enum CodingKeys: String, CodingKey {
        case currentDate = "dt_txt"
        case date = "dt"
        case mainWeather = "main"
        case wind
        case weather
    }
}

struct Weather: Codable, CommonWeatherProtocol {
    var id: Int
    var date: Int
    var nameCity: String
    var mainWeather: MainWeathertruct?
    var wind: WindStruct?
    var weather: [WeatherDataStruct]?
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.date = try container.decode(Int.self, forKey: .date)
        self.mainWeather = try container.decode(MainWeathertruct.self, forKey: .mainWeather)
        self.wind = try container.decode(WindStruct.self, forKey: .wind)
        self.weather = try container.decode([WeatherDataStruct].self, forKey: .weather)
        self.nameCity = try container.decode(String.self, forKey: .nameCity)
    }
    
    init(id: Int, nameCity: String, wind: Double, humidity: Int, tempMax: Double, tempMin: Double, temp: Double, pressure: Double, icon: String) {
        self.id = id
        self.nameCity = nameCity
        self.date = 0
        self.wind = WindStruct(speed: wind)
        self.mainWeather = MainWeathertruct(humidity: humidity, tempMax: tempMax, tempMin: tempMin, temp: temp, pressure: pressure)
        self.weather = [WeatherDataStruct(icon: icon)]
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case date = "dt"
        case mainWeather = "main"
        case wind
        case nameCity = "name"
        case weather
    }
}
