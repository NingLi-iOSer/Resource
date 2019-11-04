//
//  ViewController.swift
//  PopoverView
//
//  Created by Ning Li on 2019/8/27.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit
import Popover

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction private func showPopoverView(sender: UIButton) {
        let actions = [MSPopoverAction(title: "扫一扫", image: #imageLiteral(resourceName: "btn_scan_qr_code_gray"), index: 0),
                       MSPopoverAction(title: "以图搜图", image: #imageLiteral(resourceName: "icon-search-by-map"), index: 1)]
        MSPopoverView.show(actions: actions, from: sender) { (index) in
            
        }
    }
}

struct MSPopoverView {
    
    static func createTableView(actions: [MSPopoverAction], complete: ((_ action: MSPopoverAction) -> Void)?) -> UITableView {
        let height: CGFloat = CGFloat(actions.count) * actions[0].height
        let v = MSPopoverTableView(actions: actions, frame: CGRect(origin: CGPoint(), size: CGSize(width: 100, height: height)), complete: complete)
        return v
    }
    
    static func show(actions: [MSPopoverAction], from: UIView, complete: ((_ action: MSPopoverAction) -> Void)?) {
        if actions.isEmpty {
            return
        }
        let content = createTableView(actions: actions) { action in
            //            popover.dismiss()
            complete?(action)
        }
        let options = [
            .type(.down),
            .cornerRadius(4),
            .blackOverlayColor(UIColor.clear),
            .animationIn(0.3),
            .arrowSize(CGSize(width: 10, height: 8))
            ] as [PopoverOption]
        let popover = Popover(options: options, showHandler: nil, dismissHandler: nil)
        popover.show(content, fromView: from)
        popover.layer.shadowColor = UIColor.gray.cgColor
        popover.layer.shadowOffset = CGSize(width: -2, height: 2)
        popover.layer.shadowOpacity = 0.5
    }
}
