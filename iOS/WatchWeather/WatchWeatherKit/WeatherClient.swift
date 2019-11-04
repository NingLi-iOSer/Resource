//
//  WeatherClient.swift
//  WatchWeatherKit
//
//  Created by Ning Li on 2019/10/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

public let WatchWeatherKitErrorDomain = "com.onevcat.WatchWeatherKit.error"

public struct WatchWeatherKitError {
    public static let corrutedJSON = 1000
}

public struct WeatherClient {
    public static let sharedClient = WeatherClient()
    let session = URLSession.shared
    
    public func requestWeathers(handler: ((_ weather: [Weather?]?, _ error: Error?) -> Void)?) {
        guard let url = URL(string: "https://raw.githubusercontent.com/onevcat/WatchWeather/master/Data/data.json") else {
            handler?(nil, NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil) as Error)
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.async {
                    handler?(nil, error)
                }
            } else {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let dict = object as? [String: Any] {
                        DispatchQueue.main.async {
                            handler?(Weather.parseWeatherResult(dict: dict), nil)
                        }
                    }
                } catch _ {
                    DispatchQueue.main.async {
                        handler?(nil, NSError(domain: WatchWeatherKitErrorDomain, code: WatchWeatherKitError.corrutedJSON, userInfo: nil))
                    }
                }
            }
        }
        task.resume()
    }
}
