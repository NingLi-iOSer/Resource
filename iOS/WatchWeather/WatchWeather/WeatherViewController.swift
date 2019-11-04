//
//  WeatherViewController.swift
//  WatchWeather
//
//  Created by Ning Li on 2019/10/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import WatchWeatherKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    
    var weather: Weather? {
        didSet {
            title = weather?.day.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        highTemperatureLabel.text = "\(weather!.highTemperature)℃"
        lowTemperatureLabel.text = "\(weather!.lowTemperature)℃"
        
        let imageName: String
        switch weather!.state {
        case .Sunny:
            imageName = "sunny"
        case .Cloudy:
            imageName = "cloudy"
        case .Rain:
            imageName = "rain"
        case .Snow:
            imageName = "snow"
        }
        
        weatherImageView.image = UIImage(named: imageName)
    }
}
