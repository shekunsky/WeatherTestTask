//
//  CityParserClass.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

class CityParserClass {
    
    class func getAllCities() -> [CitiesListStruct] {
        
        var citiesList = [CitiesListStruct]()
        let podBundle = Bundle(for: self)
        
        if let path = podBundle.path(forResource: "CitiesList", ofType: "json") {
            
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSData.ReadingOptions.mappedIfSafe)
                do {
                    let jsonResult: [[String : Any]] = try JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String : Any]]
                    
                    for nation in jsonResult {
                        var city = CitiesListStruct()
                        city.cityId = nation["id"] as! Int
                        city.country = nation["country"] as! String
                        city.name = nation["name"] as! String
                        citiesList.append(city)
                    }
                    
                } catch {}
            } catch {}
        }
        
        return citiesList
    }
    
}

