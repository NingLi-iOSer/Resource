//
//  MSBaseController.swift
//  ManagementSystem
//
//  Created by Apple on 2018/3/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class MSBaseController: UIViewController, MSThemeStyle {
    
    lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.hexColor(hex: 0x111111), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)]
        return navBar
    }()
    lazy var navItem = UINavigationItem()
    
    var tableView: UITableView?
    /// 导航栏标题
    var navTitle: String?
    
    /// 状态栏样式
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /// tabBar normal 图标
    var tabBarItemImage: UIImage? {
        didSet {
             navigationController?.tabBarItem.image = tabBarItemImage
        }
    }
    
    /// tabBar 选中图标
    var tabBarItemSelectedImage: UIImage? {
        didSet {
            navigationController?.tabBarItem.selectedImage = tabBarItemSelectedImage
        }
    }
    
    /// tabBat 标题
    var tabBarTitle: String? {
        didSet {
            navigationController?.tabBarItem.title = tabBarTitle
        }
    }
    
    /// 置顶按钮
    var topButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "btn_top"), for: .normal)
        button.isHidden = true
        button.cornerRadius = 20
        button.layer.shadowColor = UIColor.hexColor(hex: 0x000000).cgColor
        button.layer.shadowOffset.height = 1
        button.layer.shadowOpacity = 0.2
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        return button
    }()
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        
        if navTitle != nil {
            navItem.title = navTitle
        }
        
        if navigationController?.children.count == 1 || navigationController == nil {
            navItem.leftBarButtonItem = nil
            if #available(iOS 11, *) { }
            else {
                tableView?.contentInset.bottom = kTabbarHeight
                tableView?.scrollIndicatorInsets.bottom = kTabbarHeight
            }
        }
        
        if tableView != nil {
            
            tableView?.estimatedRowHeight = 0
            tableView?.estimatedSectionHeaderHeight = 0
            tableView?.estimatedSectionFooterHeight = 0
        }
        if #available(iOS 11, *) { }
        else {
            view.insertSubview(UIView(), at: 0)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    func settingUI() {
        navBar.items = [navItem]
        
        view.addSubview(navBar)
        navBar.frame = CGRect(
        navBar.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
            
            if let parent = parent,
                parent is UINavigationController {
                make.top.equalToSuperview().offset(kStatusBarHeight)
            } else {
                make.top.equalToSuperview()
            }
        }
        
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && view.window == nil {
            self.view = nil
        }
    }
    
    deinit {
        view = nil
    }
    
    func push(_ vc: UIViewController, removePrevious: Bool = false) {
        if let nav = navigationController as? MSNavigationController {
            nav.push(vc, removePrevious: removePrevious)
        } else {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
}

// MARK: - 公开方法
extension MSBaseController {
    /// 隐藏置顶按钮
    func hiddenTopButton() {
        if topButton.isHidden {
            return
        }
        topButton.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset(20)
        }
        topButton.isUserInteractionEnabled = false
        UIView.animate(withDuration: kAnimationDuration * 2) {
            self.view.layoutIfNeeded()
            self.topButton.alpha = 0.3
        }
    }
    
    /// 显示置顶按钮
    func showTopButton() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuration) {
            if self.topButton.isUserInteractionEnabled || self.tableView!.isDragging || self.tableView!.isDecelerating {
                return
            }
            self.topButton.isUserInteractionEnabled = true
            self.topButton.snp.updateConstraints { (make) in
                make.right.equalToSuperview().offset(-15)
            }
            UIView.animate(withDuration: kAnimationDuration * 2) {
                self.view.layoutIfNeeded()
                self.topButton.alpha = 1.0
            }
        }
    }
}

// MARK: - 监听事件
extension MSBaseController {
    /// 返回上级控制器
    @objc func backToPreviousVC() {
        navigationController?.popViewController(animated: true)
    }
    
    /// 保存
    @objc func saveInfo() {
        
    }
    
    /// 显示更多功能
    @objc func showMoreInfo() {
        
    }
    
    /// 取消按钮点击
    @objc func cancelItemClick() {
        backToPreviousVC()
        dismiss(animated: true, completion: nil)
    }
    
    /// 新建
    @objc func createNew() {
        
    }
    
    /// 确定
    @objc func confirmItemClick() {
        
    }
    
    /// 滚动到顶部
    @objc private func scrollToTop() {
        tableView?.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
