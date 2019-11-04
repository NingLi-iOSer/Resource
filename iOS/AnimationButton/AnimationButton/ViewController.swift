//
//  ViewController.swift
//  AnimationButton
//
//  Created by Ning Li on 2018/12/25.
//  Copyright © 2018 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = LNAnimationButton()
        button.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 44)
        button.backgroundColor = UIColor(red: 67 / 255.0, green: 152 / 255.0, blue: 246 / 255.0, alpha: 1)
        button.setTitle("确定", status: .normal)
        button.setTitle("正在提交", status: .loading)
        button.setTitle("提交成功", status: .success)
        view.addSubview(button)
    }
}

