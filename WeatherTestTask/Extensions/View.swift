//
//  View.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

extension UIView {
    
    var loadingIndicator: UIActivityIndicatorView? {
        get {
            return self.viewWithTag(9999) as? UIActivityIndicatorView
        }
    }
    
    func loadingIndicator(_ show: Bool, style: UIActivityIndicatorView.Style = .white) {
        
        if show {
            
            let viewHeight = self.bounds.size.height
            let viewWidth = self.bounds.size.width
            let indicator = (self.viewWithTag(9999) as? UIActivityIndicatorView) ?? UIActivityIndicatorView(style: style)
            indicator.center = CGPoint(x: viewWidth/2, y: viewHeight/2)
            indicator.tag = 9999
            indicator.color = .red
            
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.loadingIndicator {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
