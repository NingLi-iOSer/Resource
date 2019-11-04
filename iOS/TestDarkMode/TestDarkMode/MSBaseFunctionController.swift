//
//  MSBaseFunctionController.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/// 带排序和筛选的基控制器
class MSBaseFunctionController: MSBaseController, MSListThemeStyle {
    /// 获取单条数据
    var isNeedLoad: Bool = false
    /// 需要加载的数据 id
    var id: Int?
    /// 是否需要刷新标记
    var isNeedRefresh: Bool = false
    
    /// 列表
    @IBOutlet weak var mainTableView: UITableView!
    /// 排序按钮
    @IBOutlet weak var sortButton: MSTextImageButton!
    /// 排序筛选视图
    @IBOutlet weak var functionView: UIView!
    /// 筛选按钮
    @IBOutlet weak var filterButton: MSTextImageButton!
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isNeedRefresh && isNeedLoad {
            loadData(id: id)
        }
    }
    
    // MARK: - 设置界面
    override func settingUI() {
        super.settingUI()
        
        tableView = mainTableView
        mainTableView.contentInset.top = 5
        mainTableView.ms_footerViewHeight(1)
        // 上拉下拉刷新
        mainTableView.mj_header = refreshHeader
        mainTableView.mj_footer = refreshFooter
    }
    
    /// 加载数据
    ///
    /// - Parameters:
    ///   - id: id
    ///   - isPullup: 是否是上拉加载
    func loadData(id: Int? = nil, isPullup: Bool = false) {
        
    }
}


// MARK: - 监听事件
extension MSBaseFunctionController {
    /// 排序
    @IBAction func sortButtonClick(button: MSTextImageButton) {
        
    }
    
    /// 筛选
    @IBAction func filterButtonClick() {
        
    }
    
    /// 新建
    override func createNew() {
        
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MSBaseFunctionController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topButton.isHidden = (scrollView.contentOffset.y < 1000)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hiddenTopButton()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            showTopButton()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        showTopButton()
    }
}
