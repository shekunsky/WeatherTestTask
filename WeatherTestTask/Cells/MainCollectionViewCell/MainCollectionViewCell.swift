//
//  MainCollectionViewCell.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/8/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    func configured(withModel weather: Weather?) -> Self {
        if let name = weather?.nameCity {
            cityLabel.text = name
        }
        if let tempMax = weather?.mainWeather?.tempMax, let tempMin = weather?.mainWeather?.tempMin {
            degreesLabel.text = String(format: "%d%@C / %d%@C", Int(tempMax), "\u{00B0}", Int(tempMin), "\u{00B0}")
        }
        if let urlString = weather?.weather?.first?.icon {
            weatherImageView.setImage(urlString: urlString)
        }
        return self
    }

}
