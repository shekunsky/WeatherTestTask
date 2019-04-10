//
//  WeatherByHoursCollectionViewCell.swift
//  WeatherTestTask
//
//  Created by Alex2 on 4/9/19.
//  Copyright © 2019 Alex Shekunsky. All rights reserved.
//

import UIKit

class WeatherByHoursCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? ColorConstants.kCollectionCellSelected : ColorConstants.kCollectionCellDark
        }
    }
    
    func configured(withModel weather: WeatherForecastStruct?) -> Self {
        contentView.backgroundColor = ColorConstants.kCollectionCellDark
        timeLabel.text = weather?.currentDate.getTime()
        if let date = weather?.date {
            dayLabel.text =  Date(timeIntervalSince1970: TimeInterval(date)).dayOfWeek()
        }
        if let temp = weather?.mainWeather?.temp {
            degreesLabel.text = String(format: "%d%@", Int(temp), "\u{00B0}")
        }
        
        if let urlString = weather?.weather?.first?.icon {
            iconImageView.setImage(urlString: urlString)
        }
        return self
    }
}


