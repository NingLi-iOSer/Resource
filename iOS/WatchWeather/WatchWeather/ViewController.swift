//
//  ViewController.swift
//  WatchWeather
//
//  Created by Ning Li on 2019/10/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import WatchWeatherKit

class ViewController: UIPageViewController {
    
    lazy var data = [Day: Weather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        let vc = UIViewController()
        setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        WeatherClient.sharedClient.requestWeathers { (weather, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil && weather != nil {
                for w in weather! where w != nil {
                    self.data[w!.day] = w
                }
                
                let vc = self.weatherViewControllerForDay(day: .Today)
                self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func weatherViewControllerForDay(day: Day) -> UIViewController {
        let vc: WeatherViewController
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "WeatherViewController") as! WeatherViewController
        } else {
            vc = storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        }
        let nav = UINavigationController(rootViewController: vc)
        vc.weather = data[day]
        return nav
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let nav = viewController as? UINavigationController,
            let viewController = nav.viewControllers.first as? WeatherViewController,
            let day = viewController.weather?.day
            else {
                return nil
        }
        
        if day == .DayBeforeYesterday {
            return nil
        }
        
        guard let earlierDay = Day(rawValue: day.rawValue - 1) else {
            return nil
        }
        return weatherViewControllerForDay(day: earlierDay)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let nav = viewController as? UINavigationController,
            let viewController = nav.viewControllers.first as? WeatherViewController,
            let day = viewController.weather?.day
            else {
                return nil
        }
        
        if day == .DayAfterTomorrow {
            return nil
        }
        
        guard let laterDay = Day(rawValue: day.rawValue + 1) else {
            return nil
        }
        return weatherViewControllerForDay(day: laterDay)
    }
}
