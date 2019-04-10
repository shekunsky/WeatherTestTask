//
//  DispatchQueue.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static let networking = DispatchQueue(label: "weather.networking",
                                          qos: .default,
                                          attributes: .concurrent,
                                          autoreleaseFrequency: .inherit,
                                          target: nil)
}
