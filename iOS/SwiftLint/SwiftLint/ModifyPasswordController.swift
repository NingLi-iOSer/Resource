//
//  ModifyPasswordController.swift
//  SwiftLint
//
//  Created by Ning Li on 2019/4/1.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ModifyPasswordController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func confirm() {
        navigationController?.pushViewController(ResultPageController(), animated: true)
    }
}
