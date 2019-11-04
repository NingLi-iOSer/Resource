//
//  MSNewThemeStyle.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/// 新建控制器主题样式
protocol MSNewThemeStyle: MSThemeStyle {
    /// 取消按钮
    var cancelItem: UIBarButtonItem { get }
    
    var cancelItemWhite: UIBarButtonItem { get }
    
    /// 确定按钮
    var confirmItem: UIBarButtonItem { get }
    
    var confirmItemWhite: UIBarButtonItem { get }

    /// 保存按钮
    var saveItem: UIBarButtonItem { get }
}

extension MSNewThemeStyle where Self: MSBaseController {
    var cancelItem: UIBarButtonItem {
        let cancel = UIBarButtonItem.textItem(text: "取消", target: self, action: #selector(cancelItemClick), textColor: UIColor.hexColor(hex: 0x333333), fontSize: 16)
        return cancel
    }
    
    var cancelItemWhite: UIBarButtonItem {
        let cancel = UIBarButtonItem.textItem(text: "取消", target: self, action: #selector(cancelItemClick), textColor: UIColor.white, fontSize: 16)
        return cancel
    }

    var confirmItem: UIBarButtonItem {
        let confirm = UIBarButtonItem.textItem(text: "确定", target: self, action: #selector(confirmItemClick), textColor: UIColor.hexColor(hex: 0x2777C8), fontSize: 16)
        return confirm
    }
    
    var confirmItemWhite: UIBarButtonItem {
        let confirm = UIBarButtonItem.textItem(text: "确定", target: self, action: #selector(confirmItemClick), textColor: UIColor.white, fontSize: 16)
        return confirm
    }

    var saveItem: UIBarButtonItem {
        let saveItem = UIBarButtonItem.textItem(text: "保存", target: self, action: #selector(saveInfo), textColor: UIColor.hexColor(hex: 0x2777C8), fontSize: 16)
        return saveItem
    }

    func settingThemeStyle(title: String?) {
        navItem.title = title
        navItem.leftBarButtonItem = cancelItem
        navItem.rightBarButtonItem = saveItem
    }
}
