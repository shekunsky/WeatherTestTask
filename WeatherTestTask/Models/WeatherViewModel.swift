//
//  WeatherViewModel.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherViewModel {
    
    private var weatherForecast: ListForecastWeatherStruct!
    private let locationService = LocationService()
    private var defaultCitiesArray: [String] = []
    var weather: ListOfWeatherStruct?
    var currentWeatherCity: Weather?
    
    required init() {
        defaultCitiesArray = getFavoriteCitiesList()
    }
    
    func forecastWeatherList() -> ListForecastWeatherStruct? {
        return weatherForecast
    }
    
    func removeForecastWeatherList() {
        if weatherForecast != nil {
            return weatherForecast.list.removeAll()
        }
    }
    
}

extension WeatherViewModel {
    
    func loadCitiesFromWeb(completion: @escaping (Error?) -> Void) {
        guard defaultCitiesArray.count > 0 else {
            completion(nil)
            return
        }
        
        WeatherService.getWeatherWithGroup(group: defaultCitiesArray) {[weak self] (result, error) in
            if result != nil {
                self?.weather = result
                updateWeatherFrom(list: (self?.weather!.list)!)
            }
            completion(error)
        }
    }
    
    func loadCitiesFromDb() {
        weather = getWeatherFromDb()
    }
    
    func loadWeatherByHoursFromDBForCity() {
        if let id = currentWeatherCity?.id {
            weatherForecast = getListOfWeatherByHoursFromDbForCity(id: String(id))
        }
    }
    
    func obtainForecast(completion: @escaping (Error?) -> Void) {
        guard let id = self.currentWeatherCity?.id else {
            completion(nil)
            return
        }
        WeatherService.getWeatherForecastWithId(id: id) {[weak self] (result, error) in
            if result != nil {
                self?.weatherForecast = result
                updateWeatherByHoursFrom(list: (self?.weatherForecast.list)!, id: id)
            }
            completion(error)
        }
    }
}

extension WeatherViewModel {
    
    func  setCurrentWeatherCity(withIndex: Int) {
        currentWeatherCity = weather?.list[withIndex]
    }
    
    func  getCurrentWeatherCity() -> Weather? {
        return currentWeatherCity
    }
    
    func  getCurrentWeatherCityName() -> String? {
        return currentWeatherCity?.nameCity ?? ""
    }
}

extension WeatherViewModel {
    
    func addSelectedCity(id: String) {
        defaultCitiesArray.append(id)
        setSelectedCities()
    }
    
    func deleteSelectedCity() {
        guard let id = currentWeatherCity?.id  else {
            return
        }
        
        if let index = self.defaultCitiesArray.firstIndex(of: String(id)) {
            defaultCitiesArray.remove(at: index)
            deleteFavoriteCityWith(id: String(id))
            if checkIsInternetEnabled() {
                setSelectedCities()
            }
        }
    }
    
    private func setSelectedCities() {
        setFavoriteCitiesFrom(list: defaultCitiesArray)
        let localCityId = UserDefaults.standard.string(forKey: UserDefaultsConstants.kCurrentLocalCityId) ?? ""
        guard localCityId != "" else {
            return
        }
        setCurrentLocalCityFor(id: localCityId)
    }
}

extension WeatherViewModel {
    
    func getStatusLocation() -> Bool {
        return locationService.getStatusLocation()
    }
    
    func getLocation(completion: @escaping (Error?) -> Void) {
        self.locationService.getLocation(completion: {[weak self] (location) in
            if let location = location {
                WeatherService.getWeatherWithCoordinates(lon: location.coordinate.longitude, lat: location.coordinate.latitude, completion: { (result, error) in
                    if let result = result {
                        UserDefaults.standard.set(String(result.id), forKey: UserDefaultsConstants.kCurrentLocalCityId)
                        UserDefaults.standard.synchronize()
                        if self?.weather == nil {
                         
                            self?.defaultCitiesArray = [String(result.id)]
                            self?.loadCitiesFromWeb { (error) in
                                self?.defaultCitiesArray = []
                                self?.addSelectedCity(id: String(result.id))
                                completion(error)
                            }
                        } else {
                            self?.weather?.list.append(result)
                            self?.addSelectedCity(id: String(result.id))
                        }

                    }
                    completion(error)
                })
            }
            else {
                completion(nil)
            }
        })
    }
    
}
