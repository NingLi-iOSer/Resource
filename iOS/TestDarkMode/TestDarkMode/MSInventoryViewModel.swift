//
//  MSInventoryViewModel.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

/// 库存列表视图模型
class MSInventoryViewModel {
    
    /// 一次加载的库存列表数据
    lazy var singleData = [MSInventoryListModel]()
    /// 所有的库存列表数据
    lazy var totalData = [MSInventoryModel]()
    
    lazy var hasNextPage: Bool = true
    
    /// 加载库存列表
    func loadInventoryList(completion:@escaping ()->()) {
        let path = Bundle.main.url(forResource: "data", withExtension: nil)!
        let data = try! Data(contentsOf: path)
        let decoder = JSONDecoder()
        guard let array = (try? decoder.decode([MSInventoryListModel].self, from: data)),
            let listModels = array.first?.dataList
            else {
                completion()
                return
        }
        singleData.append(array[0])
        totalData.append(contentsOf: listModels)
        
        hasNextPage = array[0].currentPage != array[0].totalPage
        completion()
    }
}
