//
//  CitiesList.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import RealmSwift

class CitiesList: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var cityId = ""
    @objc dynamic var name          = ""
    @objc dynamic var country       = ""
}

struct CitiesListStruct {
    var cityId        = 0
    var name          = ""
    var country       = ""
}
