//
//  CityModel.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

@objc protocol SearchCity {
    @objc  optional var id: Int64 {get set}
    @objc  optional var country: String {get set}
    @objc  optional var code: String {get set}
    var name: String {get set}
}
