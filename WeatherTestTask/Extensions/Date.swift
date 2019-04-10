//
//  Date.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

extension Date {
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
