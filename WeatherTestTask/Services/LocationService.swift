//
//  LocationService.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService : NSObject {
    
    private let manager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?
    
    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.manager.requestWhenInUseAuthorization()
    }
    
    func getStatusLocation() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .restricted, .denied, .notDetermined:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }
    
    func getLocation(completion: @escaping ((CLLocation?) -> Void)) {
        self.completion = completion
        manager.startUpdatingLocation()
    }
}

extension LocationService : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
            NotificationCenter.default.post(name: Notification.Name(NotificationsConstants.kReceivedPermissionForLocationsNotification), object: nil)
        } else if status != .notDetermined {
            NotificationCenter.default.post(name: Notification.Name(NotificationsConstants.kFailedPermissionForLocationsNotification), object: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        completion?(nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            completion?(nil)
            return
        }
        completion?(location)
        completion = nil
        manager.stopUpdatingLocation()
    }
}
