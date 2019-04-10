//
//  Segue.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

extension UIStoryboardSegue {
    func destination<T: UIViewController>(withType type: T.Type) -> T? {
        if let viewController = self.destination as? T {
            return viewController
        } else {
            return nil
        }
    }
}

