//
//  DbService.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

//REALM config
var realmConfiguration: Realm.Configuration = {
    var configuration = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
        // totalBytes refers to the size of the file on disk in bytes (data + free space)
        // usedBytes refers to the number of bytes used by data in the file
        
        // Compact if the file is over 10MB in size and less than 50% 'used'
        let oneHundredMB = 10 * 1024 * 1024
        return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
    })
    
    configuration.schemaVersion = 1
    configuration.migrationBlock = { migration, oldSchemaVersion in
        
        if (oldSchemaVersion < 1) {
            
        }
    }
    configuration.objectTypes = [CitiesList.self, FavoriteCities.self, WeatherForCity.self, WeatherByHours.self]
    return configuration
}()

private func initRealm() -> Realm {
    return try! Realm(configuration: realmConfiguration)
}

//MARK: - CitiesList
func deleteAllCities() {
    let realm = initRealm()
    let allCities = realm.objects(CitiesList.self)
    try! realm.write {
        realm.delete(allCities)
    }
}

func FillCitiesDbFrom(_ arrayOfStruct: [CitiesListStruct]) {
    deleteAllCities()
    let realm = initRealm()
    var cities = [CitiesList]()
    for city in arrayOfStruct {
        let newCity = CitiesList()
        newCity.cityId = String(city.cityId)
        newCity.country = city.country
        newCity.name = city.name
        
       cities.append(newCity)
    }
    
    try! realm.write {
        realm.add(cities)
    }
}

func getCitiesForCountry(code: String) -> [CitiesListStruct] {
    let realm = initRealm()
    let cities = realm.objects(CitiesList.self).filter { $0.country == code }
    var citiesList = [CitiesListStruct]()
    for city in cities {
        var newCity = CitiesListStruct()
        newCity.cityId = Int(city.cityId)!
        newCity.name = city.name
        newCity.country = city.country
        
        citiesList.append(newCity)
    }
    
    return citiesList
}

//MARK: - FavoriteCities
func setFavoriteCitiesFrom(list: [String]) {
    
    //delete all favorite cities
    let realm = initRealm()
    let allCities = realm.objects(FavoriteCities.self)
    try! realm.write {
        realm.delete(allCities)
    }
    
    //save new list
    var newList = [FavoriteCities]()
    for id in list {
        let newCity = FavoriteCities()
        newCity.cityId = id
        if let localCityId = UserDefaults.standard.string(forKey: UserDefaultsConstants.kCurrentLocalCityId) {
            newCity.isLocal = (id == localCityId)
        }
        //reattach weather
        let weathers = realm.objects(WeatherForCity.self).filter { $0.cityId == id }
        if let weather = weathers.first {
            newCity.weather = weather
        }
        
        newList.append(newCity)
    }
    
    try! realm.write {
        realm.add(newList)
    }
}

func getFavoriteCitiesList() -> [String] {
    let realm = initRealm()
    let cities = realm.objects(FavoriteCities.self)
    
    var list = [String]()
    for city in cities {
        list.append(city.cityId)
    }
    
    return list
}

func setCurrentLocalCityFor(id: String) {
    let realm = initRealm()
    let cities = realm.objects(FavoriteCities.self)
    
    try! realm.write {
        for city in cities {
            if city.cityId == id {
                city.isLocal = true
            } else {
                city.isLocal = false
            }
        }
    }
}

func idOfLocalCity() -> String {
    let realm = initRealm()
    let cities = realm.objects(FavoriteCities.self).filter { $0.isLocal == true }
    if let localCity = cities.first {
        return localCity.cityId
    } else {
        return ""
    }
    
}

func isWasAddedCityWith(id: String) -> Bool {
    let realm = initRealm()
    let cities = realm.objects(FavoriteCities.self).filter { $0.cityId == id }
    
    return cities.count > 0
}

func deleteFavoriteCityWith(id: String) {
    let realm = initRealm()
    
    //delete old weatherByHours for this city
    deleteWeatherByHoursForCity(id: String(id))
    
    //delete weather for city and city
    let weather = realm.objects(WeatherForCity.self).filter { $0.cityId == id }
    let cities = realm.objects(FavoriteCities.self).filter { $0.cityId == id }
    try! realm.write {
        realm.delete(weather)
        realm.delete(cities)
    }
}

//MARK: Weather for cities
func updateWeatherFrom(list: [Weather]) {
    let realm = initRealm()
    
    for weather in list {
        let city = realm.objects(FavoriteCities.self).filter { $0.cityId == String(weather.id) }.first
        if let cityWeather = city?.weather {
            //edit weather for city
            try! realm.write {
                cityWeather.cityId = String(weather.id)
                cityWeather.nameCity = weather.nameCity
                cityWeather.wind = Int(weather.wind?.speed ?? 0)
                cityWeather.humidity = weather.mainWeather?.humidity ?? 0
                cityWeather.tempMax = Int(weather.mainWeather?.tempMax ?? 0)
                cityWeather.tempMin = Int(weather.mainWeather?.tempMin ?? 0)
                cityWeather.temp = Int(weather.mainWeather?.temp ?? 0)
                cityWeather.pressure = Int(weather.mainWeather?.pressure ?? 0)
                cityWeather.weatherIcon = weather.weather?.first?.icon
            }
            
        } else {
            //create new weather for city
            let newWeather = WeatherForCity()
            newWeather.cityId = String(weather.id)
            newWeather.nameCity = weather.nameCity
            newWeather.wind = Int(weather.wind?.speed ?? 0)
            newWeather.humidity = weather.mainWeather?.humidity ?? 0
            newWeather.tempMax = Int(weather.mainWeather?.tempMax ?? 0)
            newWeather.tempMin = Int(weather.mainWeather?.tempMin ?? 0)
            newWeather.temp = Int(weather.mainWeather?.temp ?? 0)
            newWeather.pressure = Int(weather.mainWeather?.pressure ?? 0)
            newWeather.weatherIcon = weather.weather?.first?.icon
            
            try! realm.write {
                city?.weather = newWeather
            }
        }
    }
}

func getWeatherFromDb() -> ListOfWeatherStruct {
    var listWeather: ListOfWeatherStruct
    listWeather = ListOfWeatherStruct(list: [])
    let realm = initRealm()
    let cities = realm.objects(FavoriteCities.self)
    for city in cities {
        let weather = Weather(id: Int(city.cityId) ?? 0,
                              nameCity: city.weather?.nameCity ?? "",
                              wind: Double(city.weather?.wind ?? Int(0.00)),
                              humidity: city.weather?.humidity ?? 0,
                              tempMax: Double(city.weather?.tempMax ?? Int(0.00)),
                              tempMin: Double(city.weather?.tempMin ?? Int(0.00)),
                              temp: Double(city.weather?.temp ?? Int(0.00)),
                              pressure: Double(city.weather?.pressure ?? Int(0.00)),
                              icon: city.weather?.weatherIcon ?? "")
        listWeather.list.append(weather)
    }
    return listWeather
}

//MARK: Weather by hours
func updateWeatherByHoursFrom(list: [WeatherForecastStruct], id: Int) {
    let realm = initRealm()
    let city = realm.objects(FavoriteCities.self).filter { $0.cityId == String(id) }.first
    
    //delete old weatherByHours for this city
    deleteWeatherByHoursForCity(id: String(id))
    
    let newList = List<WeatherByHours>()
    for weather in list {
        let newWeather = WeatherByHours()
        newWeather.cityId = String(id)
        newWeather.date = weather.date
        newWeather.currentDate = weather.currentDate
        newWeather.temp = Int(weather.mainWeather?.temp ?? 0)
        newWeather.weatherIcon = weather.weather?.first?.icon
        newWeather.wind = Int(weather.wind?.speed ?? 0)
        newWeather.humidity = weather.mainWeather?.humidity ?? 0
        newWeather.tempMax = Int(weather.mainWeather?.tempMax ?? 0)
        newWeather.tempMin = Int(weather.mainWeather?.tempMin ?? 0)
        newWeather.pressure = Int(weather.mainWeather?.pressure ?? 0)
        
        newList.append(newWeather)
    }
    try! realm.write {
        realm.add(newList)
        city?.weatherByHours = newList
    }
}

func getListOfWeatherByHoursFromDbForCity(id: String) -> ListForecastWeatherStruct{
    var listForecastWeather = ListForecastWeatherStruct(list: [])
    let realm = initRealm()
    let listOfWeather = realm.objects(WeatherByHours.self).filter { $0.cityId == id }
    for hours in listOfWeather {
        let weatherForecast = WeatherForecastStruct(currentDate: hours.currentDate,
                                              date: hours.date,
                                              wind: Double(hours.wind),
                                              humidity: hours.humidity,
                                              tempMax: Double(hours.tempMax),
                                              tempMin: Double(hours.tempMin),
                                              temp: Double(hours.temp),
                                              pressure: Double(hours.pressure),
                                              icon: hours.weatherIcon ?? "")
        
        listForecastWeather.list.append(weatherForecast)
    }
    return listForecastWeather
}

func deleteWeatherByHoursForCity(id: String) {
    let realm = initRealm()
    let listOfWeatherByHoursForCity = realm.objects(WeatherByHours.self).filter { $0.cityId == id }
    try! realm.write {
        realm.delete(listOfWeatherByHoursForCity)
    }
}

//MARK: Internet
func checkIsInternetEnabled(showMessage: Bool = true) -> Bool {
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    return (manager?.isReachable)!
}
