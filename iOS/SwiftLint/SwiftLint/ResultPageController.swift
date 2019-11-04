//
//  ResultPageController.swift
//  SwiftLint
//
//  Created by Ning Li on 2019/4/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ResultPageController: UIViewController {
    
    @IBOutlet weak var tipLabel: UILabel!
    
    private var timers: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GCDTimer.makeTimer(duration: .seconds(1)) { (timer) in
            if self.timers >= 0 {
                self.tipLabel.text = "修改成功，\(self.timers)秒自动跳转登陆页"
            } else {
                timer.cancel()
                self.navigationController?.popViewController(animated: true)
            }
            self.timers -= 1
        }
    }
}
