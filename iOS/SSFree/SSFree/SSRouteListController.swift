//
//  SSRouteListController.swift
//  SSFree
//
//  Created by Ning Li on 2019/12/17.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

/// 路线列表
class SSRouteListController: UIViewController {
    
    private lazy var navBar = UINavigationBar(frame: CGRect())
    private lazy var navItem = UINavigationItem(title: "选择路线")
    
    class func routeList() -> SSRouteListController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "RouteList") as! SSRouteListController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_back"), style: .plain, target: self, action: #selector(back))
        navBar.items = [navItem]
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        view.addSubview(navBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewSafeAreaInsetsDidChange() {
        let y = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        navBar.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 44)
    }
    
    @objc private func back() {
        navigationController?.popViewController(animated: true)
    }
}
