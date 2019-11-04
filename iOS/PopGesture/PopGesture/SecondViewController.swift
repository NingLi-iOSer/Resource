//
//  SecondViewController.swift
//  PopGesture
//
//  Created by Ning Li on 2019/3/28.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private var timers: Int = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countDownButton = CountDownButton.make(textColor: UIColor.white,
                                                   bgColor: UIColor.blue,
                                                   disableBGColor: UIColor.orange,
                                                   fontSize: 16)
        countDownButton.bounds.size = CGSize(width: 100, height: 40)
        countDownButton.center = view.center
        countDownButton.addTarget(self, action: #selector(start(sender:)), for: .touchUpInside)
        view.addSubview(countDownButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        openPopGesture()
    }
    
    @objc func start(sender: CountDownButton) {
        sender.startCountDown(duration: 10)
    }
    
}

extension UIViewController {
    
    func closePopGesture() {
        if let navController = navigationController,
            navController.responds(to: #selector(getter: navController.interactivePopGestureRecognizer)),
            let gestureArray = navController.interactivePopGestureRecognizer?.view?.gestureRecognizers {
            gestureArray.forEach { $0.isEnabled = false }
        }
    }
    
    func openPopGesture() {
        if let navController = navigationController,
            navController.responds(to: #selector(getter: navController.interactivePopGestureRecognizer)),
            let gestureArray = navController.interactivePopGestureRecognizer?.view?.gestureRecognizers {
            gestureArray.forEach { $0.isEnabled = true }
        }
    }
}
