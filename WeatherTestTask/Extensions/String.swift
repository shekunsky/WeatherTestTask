//
//  String.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import Foundation

extension String {
    
    func getTime() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
        
        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        } else {
            return "00:00"
        }
    }
}
