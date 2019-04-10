//
//  ImageView.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(urlString: String) {
        if let urlImage = URL(string: String(format: ApiConstants.kApiUrlForImages, urlString)) {
            self.sd_setImage(with: urlImage, completed: nil)
        }
    }
}
