//
//  FavoriteCities.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteCities: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var cityId = ""
    @objc dynamic var isLocal = false
    @objc dynamic var weather: WeatherForCity?
    dynamic var weatherByHours: List<WeatherByHours>?
}

class WeatherForCity: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var cityId = ""
    @objc dynamic var nameCity = ""
    @objc dynamic var wind: Int = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var tempMax: Int = 0
    @objc dynamic var tempMin: Int = 0
    @objc dynamic var temp: Int = 0
    @objc dynamic var pressure: Int = 0
    @objc dynamic var weatherIcon: String?
}

class WeatherByHours: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var cityId = ""
    @objc dynamic var currentDate = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var temp: Int = 0
    @objc dynamic var wind: Int = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var tempMax: Int = 0
    @objc dynamic var tempMin: Int = 0
    @objc dynamic var pressure: Int = 0
    @objc dynamic var weatherIcon: String?
}
