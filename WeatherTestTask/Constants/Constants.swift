//
//  Constants.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import UIKit

struct UserDefaultsConstants {
    static let kIsAppWasLaunchedBefore  = "kIsAppWasLaunchedBefore"
    static let kCitiesDbIsInitialized  = "kCitiesDbIsInitialized"
    static let kIsCurrentCityWasSet = "kIsCurrentCityWasSet"
    static let kCurrentLocalCityId = "kCurrentLocalCityId"
}

struct NotificationsConstants {
    static let kReceivedPermissionForLocationsNotification  = "kReceivedPermissionForLocationsNotification"
    static let kFailedPermissionForLocationsNotification  = "kFailedPermissionForLocationsNotification"
    static let kInternetAvailableNotification = "kInternetAvailableNotification"
    static let kInternetDisabledNotification = "kInternetDisabledNotification"
    static let kCitiesDbInitializedNotification = "kCitiesDbInitializedNotification"
}

struct ApiConstants {
    static let kApiBaseURL = "http://api.openweathermap.org/data/2.5/"
    static let kApiKey = "937ec5e8c967ea6bcf1ca4a6c2924c55"
    static let kApiUnits = "metric"
    static let kApiUrlForImages = "http://openweathermap.org/img/w/%@.png"
}

struct ColorConstants {
    static let kCollectionCellDark = UIColor(red: 30/255, green: 10/255, blue: 60/255, alpha: 1.0)
    static let kCollectionCellSelected = UIColor(red: 240/255, green: 130/255, blue: 30/255, alpha: 1.0)
    static let kTableFooterBgColor = UIColor(red: 30/255, green: 35/255, blue: 40/255, alpha: 1.0)
}
