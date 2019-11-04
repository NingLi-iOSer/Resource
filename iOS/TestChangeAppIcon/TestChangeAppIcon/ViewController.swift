//
//  ViewController.swift
//  TestChangeAppIcon
//
//  Created by Ning Li on 2019/7/5.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            if #available(iOS 10.3, *) {
                //判断是否支持替换图标, false: 不支持
                guard UIApplication.shared.supportsAlternateIcons else { return }
                
                //如果支持, 替换icon
                UIApplication.shared.setAlternateIconName("Dev2_") { (error) in
                    //点击弹框的确认按钮后的回调
                    if error != nil {
                        print(error ?? "更换icon发生错误")
                    } else {
                        print("更换成功")
                    }
                }
            }
        }
    }
}

