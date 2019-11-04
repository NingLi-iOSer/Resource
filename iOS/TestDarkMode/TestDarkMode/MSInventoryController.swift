//
//  MSInventoryController.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

/// 库存列表
class MSInventoryController: MSBaseFunctionController {
    
    /// 库存列表视图模型
    private lazy var listViewModel = MSInventoryViewModel()
    /// 筛选数据
    private lazy var filterData = [String: Any]()
    /// 初始的导航栏左侧按钮
    private var originalLeftItem: UIBarButtonItem?
    /// 交易类型选择视图
    private lazy var tradeTypeView = MSTradeTypeView.instance()
    /// 已选中的库存
    private lazy var selectedInventoryArray = [MSInventoryModel]()
    /// 正在编辑
    private var isEditingInventory: Bool = false
    /// 排序 key
    private var listSort: String?
    
    // MARK: - 初始化方法
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "MSBaseFunctionController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化 - 全局扫码调用
    ///
    /// - Parameter searchKeyword: 搜索关键字
    class func instance(searchKeyword: String?) -> MSInventoryController {
        let vc = MSInventoryController()
        vc.filterData["clothCodeKeyword"] = searchKeyword
        return vc
    }
    
    // MARK: - 设置界面
    override func settingUI() {
        super.settingUI()
        
        settingThemeStyle(title: "库存清单")
        navItem.rightBarButtonItem = nil
        sortButton.setTitle("综合", for: .normal)
        
        // 设置交易类型选择视图
        settingTradeTypeView()
        
        tableView = mainTableView
        mainTableView.rowHeight = kInventoryListCellRowHeight
        mainTableView.register(UINib(nibName: "MSInventoryListCell", bundle: nil), forCellReuseIdentifier: kInventoryListCellId)
        mainTableView.settingEmptyPlaceholder(title: "暂无库存")
        
        if !filterData.isEmpty {
            filterButton.isSelected = true
            isNeedRefresh = true
        }
    }
    
    /// 设置交易类型选择视图
    private func settingTradeTypeView() {
        tradeTypeView.isHidden = true
        tradeTypeView.alpha = 0
        view.addSubview(tradeTypeView)
        tradeTypeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(kTradeTypeViewHeight)
            make.bottom.equalToSuperview().offset(kTradeTypeViewHeight)
        }
    }
    
    /// 显示交易类型选择视图
    private func showTradeTypeView(animated: Bool = true) {
        tradeTypeView.isHidden = false
        tradeTypeView.delegate = self
        if #available(iOS 11, *) {
            tradeTypeView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(kTradeTypeViewHeight)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
        } else {
            let offset = (navigationController!.children.count == 1) ? (kTabbarHeight + kTradeTypeViewHeight) : kTradeTypeViewHeight
            tradeTypeView.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(kTradeTypeViewHeight)
                make.bottom.equalToSuperview().offset(-offset)
            }
        }
        if animated {
            UIView.animate(withDuration: kAnimationDuration) {
                self.view.layoutIfNeeded()
                self.tradeTypeView.alpha = 1.0
            }
        } else {
            tradeTypeView.alpha = 1.0
        }
    }
    
    /// 隐藏库存功能视图
    private func hideInventoryFunctionView() {
        tradeTypeView.delegate = nil
        tradeTypeView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(kTradeTypeViewHeight)
            make.bottom.equalToSuperview().offset(kTradeTypeViewHeight)
        }
        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.view.layoutIfNeeded()
            self.tradeTypeView.alpha = 0
        }) { (_) in
            self.tradeTypeView.isHidden = true
        }
    }
    
    // MARK: - 加载数据
    override func loadData(id: Int?, isPullup: Bool) {
        listViewModel.loadInventoryList(id: id, isPullup: isPullup, listSort: listSort, filterData: filterData) { [weak self] (errorInfo) in
            if self?.listViewModel.hasNextPage == false {
                self?.refreshFooter.endRefreshingWithNoMoreData()
            } else {
                self?.refreshFooter.endRefreshing()
            }
            self?.refreshHeader.endRefreshing()
            self?.isNeedRefresh = false
            self?.isNeedLoad = false
            self?.id = nil
            
            if errorInfo == nil {
                let hasData = (self?.listViewModel.totalData.count ?? 0) > 0
                self?.refreshFooter.isHidden = !hasData
                if id != nil {
                    self?.mainTableView.reloadData()
                } else {
                    // 加载成功处理
                    self?.loadDataSuccessHandler(isPullup: isPullup)
                    self?.mainTableView.hiddenPlaceholderView(hasData)
                    if self?.filterData.isEmpty == true {
                        self?.mainTableView.settingEmptyPlaceholder(title: "暂无库存")
                    } else {
                        self?.mainTableView.settingNoResultPlaceholder()
                    }
                }
            } else {
                MSHUD.show(message: errorInfo)
            }
        }
    }
    
    /// 立即下单
    private func placeOrder(items: [MSSalesOrderItemModel]) {
        let vc = MSNewSalesOrderController.instance(cloths: items, tradeType: items.first!.trade) {
            self.exitEditing()
            self.isNeedRefresh = true
        }
        push(vc)
    }
}

// MARK: - 数据加载, 处理
extension MSInventoryController {
    /// 加载列表数据成功后处理
    private func loadDataSuccessHandler(isPullup: Bool) {
        // 下拉刷新, 显示总米数, 总匹数
        if let tip = listViewModel.singleData.first?.listDescription,
            !isPullup {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + kAnimationDuration) {
                self.mainTableView.showRefreshSuccessTip(tip: tip)
            }
        }
        
        if !isPullup {
            selectedInventoryArray.removeAll()
        }
        
        // 判断是否正在编辑库存列表
        if isEditingInventory {
            listViewModel.totalData.forEach { $0.isEditing = true }
        }
        mainTableView.reloadData()
    }
}

// MARK: - 监听事件
extension MSInventoryController {
    /// 排序
    override func sortButtonClick(button: MSTextImageButton) {
        button.isSelected = !button.isSelected
        if button.isSelected { // 添加排序列表
            let sortView = MSSortTypeView.instance(sortKey: listSort, URLStirng: "/listSort/inventory") { [unowned self] (listChooseModel) in
                self.sortButton.isSelected = false
                if let model = listChooseModel,
                    self.listSort != model.key {
                    self.listSort = model.key
                    self.refreshHeader.beginRefreshing()
                    self.sortButton.setTitle(model.name, for: .normal)
                }
                self.sortTypeView = nil
            }
            sortTypeView = sortView
            view.addSubview(sortView)
            sortView.snp.makeConstraints({ (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(functionView.snp.bottom)
            })
        } else {
            sortTypeView?.dismiss()
            sortTypeView = nil
        }
    }
    
    /// 筛选
    override func filterButtonClick() {
        sortButton.isSelected ? sortButtonClick(button: sortButton) : ()
        view.endEditing(true)
        let vc = MSFilterController.instance(pageURLString: "/app/filterPage/inventory", filterCountURLString: "/app/inventory/filterCount", filterData: filterData) { [weak self] (filterData, flag, _) in
            if flag {
                self?.filterData = filterData
                self?.refreshHeader.beginRefreshing()
                self?.filterButton.isSelected = !filterData.isEmpty
            }
        }
        vc.view.frame = kWindow!.bounds
        kWindow!.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
    }
    
    /// 退出编辑
    @objc private func exitEditing() {
        isEditingInventory = false
        // 清空已选中的库存数组
        selectedInventoryArray.removeAll()
        listViewModel.totalData.forEach { $0.isEditing = false; $0.isSelected = false }
        mainTableView.reloadData()
        navItem.leftBarButtonItem = originalLeftItem
        hideInventoryFunctionView()
        // 启用指定大货按钮
        tradeTypeView.specifyLargeGoods(isEnable: true)
        
        navItem.title = "库存列表"
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MSInventoryController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.totalData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kInventoryListCellId, for: indexPath) as! MSInventoryListCell
        cell.set(listViewModel.totalData[indexPath.row], delegate: self)
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listViewModel.totalData[indexPath.row]
        self.id = model.cloth?.id
        if isEditingInventory {
            if model.isSelected == true {
                model.isSelected = false
                selectedInventoryArray = selectedInventoryArray.filter { $0.cloth?.id != model.cloth?.id }
            } else {
                model.isSelected = true
                selectedInventoryArray.append(model)
            }
            settingSpecifyLargeGoodsState()
            tableView.reloadRows(at: [indexPath], with: .none)
            return
        }
        let vc = MSInventoryDetailController.instance(cloth: model) {
            self.isNeedLoad = true
        }
        push(vc)
    }
}

// MARK: - MSInventoryListCellDelegate
extension MSInventoryController: MSInventoryListCellDelegate {
    func cell(_ cell: MSInventoryListCell, longPressFor index: Int) {
        // 修改编辑编辑
        isEditingInventory = true
        navItem.title = "选择产品"
        
        listViewModel.totalData.forEach { $0.isEditing = true }
        mainTableView.reloadData()
        // 添加到已选中库存
        selectedInventoryArray.append(listViewModel.totalData[index])
        
        originalLeftItem = navItem.leftBarButtonItem
        
        // 显示库存功能视图
        showTradeTypeView()
        
        DispatchQueue.main.async {
            // 添加退出按钮
            let exitItem = UIBarButtonItem.textItem(text: "退出", target: self, action: #selector(self.exitEditing), textColor: UIColor.white, fontSize: 16)
            self.navItem.leftBarButtonItem = exitItem
        }
    }
    
    /// 设置指定大货按钮状态
    private func settingSpecifyLargeGoodsState() {
        let enable = !(selectedInventoryArray.count > 1)
        tradeTypeView.specifyLargeGoods(isEnable: enable)
    }
}

// MARK: - MSTradeTypeViewDelegate
extension MSInventoryController: MSTradeTypeViewDelegate {
    func view(_ view: MSTradeTypeView, didSelected type: MSTradeType) {
        if selectedInventoryArray.count == 0 {
            MSHUD.show(message: "请选择产品")
            return
        }
        switch type {
        case .sampleCutting: // 剪样
            showSampleCuttingView()
        case .appointWhole: // 指定大货
            showSpecifyLargeGoodsView()
        case .normalWhole: // 常规大货
            showNormalLargeGoodsView()
        }
    }
    
    /// 获取选中的产品数组
    private func selectedCloths() -> [MSClothModel] {
        var products = [MSClothModel]()
        selectedInventoryArray.forEach { products.append($0.cloth!) }
        return products
    }
    
    /// 将库存列表产品模型转换成订单产品模型
    private func salesOrderCloths(rollCount: Int?, meterCount: Double?, tradeType: MSTradeType) -> [MSSalesOrderItemModel] {
        let cloths = selectedInventoryArray.map { (model) -> MSSalesOrderItemModel in
            let taskDescription = (rollCount == nil || rollCount == 0) ? "\(meterCount ?? 0)米" : "\(rollCount ?? 0)匹"
            return MSSalesOrderItemModel(inventoryId: model.cloth?.id, cartId: nil, taskDescription: taskDescription, cloth: model.cloth, tradeType: tradeType)
        }
        return cloths
    }
    
    /// 显示剪样视图
    private func showSampleCuttingView() {
        let products = selectedCloths()
        var stockModel: MSStockModel?
        if selectedInventoryArray.count == 1 {
            let model = selectedInventoryArray.first!
            stockModel = MSStockModel(rollCount: model.stockRollCount, meterCount: model.stockMeterCount)
        }
        let sampleCutting = MSSampleCuttingView.instance(sourceType: .other, cartId: nil, selectedCloths: products, orderCount: nil, stockCount: stockModel, unitPrice: nil) { isSuccess, isPlaceOrder, meterCount, _, itemList in
            if isSuccess {
                self.exitEditing()
                self.refreshHeader.beginRefreshing()
            }
            
            if isPlaceOrder { // 立即下单
                self.placeOrder(items: itemList)
            }
        }
        sampleCutting.settingStockCount(stock: stockModel)
        sampleCutting.show()
    }
    
    /// 显示指定大货视图
    private func showSpecifyLargeGoodsView() {
        guard let cloth = selectedCloths().first else {
            return
        }
        let vc = MSAppointWholeController.instance(cloth: cloth, appointStockIdList: nil, sourceType: .other, cartId: nil, unitPrice: nil) { (isSuccess, _, _, itemList) in
            if isSuccess {
                self.exitEditing()
                self.refreshHeader.beginRefreshing()
            }
        }
        let nav = MSNavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    /// 显示常规大货视图
    private func showNormalLargeGoodsView() {
        let products = selectedCloths()
        var stockModel: MSStockModel?
        if selectedInventoryArray.count == 1 {
            let model = selectedInventoryArray.first!
            stockModel = MSStockModel(rollCount: model.stockRollCount, meterCount: model.stockMeterCount)
        }
        let normalLargeGoodsView = MSNormalLargeGoodsView.instance(sourceType: .other, cartId: nil, selectedCloths: products, orderModel: nil, stockCount: stockModel, unitPrice: nil) { isSuccess, isPlaceOrder, roll, meter, _, itemList in
            if isSuccess {
                self.exitEditing()
                self.refreshHeader.beginRefreshing()
            }
            
            if isPlaceOrder {
                self.placeOrder(items: itemList)
            }
        }
        normalLargeGoodsView.show()
    }
}
