//
//  ViewController.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

extension UIViewController: Handler {
    
    func handleError(_ error: Error, completion: (() -> Void)? = nil) {
        if let error = error as? APIError {
            DispatchQueue.main.async {
                self.presentAlert(title: error.title, message: error.description, completion: completion)
            }
        }
    }
    
    func presentAlert(title: String, message: String?, completion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            completion?()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentLocationAlert(title: String, message: String?, completion: @escaping ((Bool) -> Void)) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            completion(true)
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            completion(false)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
