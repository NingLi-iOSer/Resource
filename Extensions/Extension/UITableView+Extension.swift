//
//  UITableView+Extension.swift
//  ManagementSystem
//
//  Created by Ning Li on 2019/6/15.
//  Copyright © 2019 Apple. All rights reserved.
//

extension UITableView: MSViewAnimation {
    
    /// 设置 tableView headerView 高度
    func ms_headerViewHeight(_ height: CGFloat) {
        tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: height))
    }
    
    /// 设置 tableView footerView 高度
    func ms_footerViewHeight(_ height: CGFloat) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        v.backgroundColor = UIColor.clear
        tableFooterView = v
    }
}
