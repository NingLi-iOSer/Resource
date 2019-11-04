//
//  TestViewController.swift
//  ScreenOrientation
//
//  Created by Ning Li on 2019/5/19.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isLandscape = true
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.isLandscape = false
        
        // MARK: - 这句很重要
        let unknownValue = UIInterfaceOrientation.unknown.rawValue
        UIDevice.current.setValue(unknownValue, forKey: "orientation")
        
        // 将视图还原成竖屏
        let orientationTarget = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
    }
    
    // 是否支持自转 看具体需求
    override var shouldAutorotate: Bool {
        return true
    }
    
    // 设置横屏方向
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // 横屏 home键在右
        return .landscapeRight
    }
}
