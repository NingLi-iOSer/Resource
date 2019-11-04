//
//  AppDelegate.swift
//  ScreenOrientation
//
//  Created by Ning Li on 2019/5/19.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var isLandscape: Bool = false


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if isLandscape {
            return [.landscapeLeft, .landscapeRight]
        } else {
            return .portrait
        }
    }


}

