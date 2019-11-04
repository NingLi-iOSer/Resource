//
//  InterfaceController.swift
//  WatchWeather WatchKit Extension
//
//  Created by Ning Li on 2019/10/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import WatchKit
import Foundation
import WatchWeatherWatchKit

class InterfaceController: WKInterfaceController {
    
    static var index = Day.DayBeforeYesterday.rawValue
    static var controllers = [Day: InterfaceController]()
    
    static var token: String = "com.ln.weather"
    
    var weather: Weather? {
        didSet {
            if let w = weather {
                updateWeather(w)
            }
        }
    }
    
    @IBOutlet weak var weatherImageView: WKInterfaceImage!
    @IBOutlet weak var highTemperatureLabel: WKInterfaceLabel!
    @IBOutlet weak var lowTemperatureLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let day = Day(rawValue: InterfaceController.index) else {
            return
        }
        
        InterfaceController.controllers[day] = self
        InterfaceController.index = InterfaceController.index + 1
        
        if day == .Today {
            becomeCurrentPage()
        }
        
        DispatchQueue.once(token: InterfaceController.token) {
            self.request()
        }
    }
    
    func request() {
        WeatherClient.sharedClient.requestWeathers { (weathers, error) in
            if let weathers = weathers {
                for weather in weathers where weather != nil {
                    guard let controller = InterfaceController.controllers[weather!.day] else {
                        continue
                    }
                    controller.weather = weather
                }
            } else {
                let action = WKAlertAction(title: "Retry", style: .default) {
                    self.request()
                }
                let errorMessage = (error != nil) ? error!.localizedDescription : "Unknown Error"
                self.presentAlert(withTitle: "Error", message: errorMessage, preferredStyle: .alert, actions: [action])
            }
        }
    }
    
    override func willActivate() {
        super.willActivate()
        if let w = weather {
            updateWeather(w)
        }
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateWeather(_ weather: Weather) {
        highTemperatureLabel.setText("\(weather.highTemperature)℃")
        lowTemperatureLabel.setText("\(weather.lowTemperature)℃")
        
        let imageName: String
        switch weather.state {
        case .Sunny:
            imageName = "sunny"
        case .Cloudy:
            imageName = "cloudy"
        case .Rain:
            imageName = "rain"
        case .Snow:
            imageName = "snow"
        }
        
        weatherImageView.setImageNamed(imageName)
    }
}
