//
//  MSInventoryListModel.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

/// 库存列表模型
class MSInventoryListModel: Decodable {
    /// 库存模型数组
    var dataList: [MSInventoryModel]?
    /// 总数
    var totalCount: Int = 0
    /// 当前页
    var currentPage: Int = 0
    var pageSize: Int = 0
    /// 上一页
    var prevPage: Int = 0
    /// 下一页
    var nextPage: Int = 0
    /// 总页数
    var totalPage: Int = 0
    /// 是否有下一页
    var hasNextPage: Bool = false
    /// 列表描述
    var listDescription: String?
}
