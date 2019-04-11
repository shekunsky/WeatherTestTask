//
//  AppDelegate.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var reachability = Reachability()!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        internetAbility()
        checkFirstLaunch()
        return true
    }
    
    private func checkFirstLaunch() {
        if !UserDefaults.standard.bool(forKey: UserDefaultsConstants.kIsAppWasLaunchedBefore) {
            //first launch
            let allCities = CityParserClass.getAllCities()
            FillCitiesDbFrom(allCities)
            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.kIsAppWasLaunchedBefore)
            UserDefaults.standard.synchronize()
        }
    }

    private func internetAbility() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            DispatchQueue.main.async{
                NotificationCenter.default.post(name: Notification.Name(NotificationsConstants.kInternetAvailableNotification), object: nil)
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            DispatchQueue.main.async{
                NotificationCenter.default.post(name: Notification.Name(NotificationsConstants.kInternetDisabledNotification), object: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}

