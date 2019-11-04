//
//  MSInventoryModel.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

/// 库存模型
class MSInventoryModel: Decodable {
    /// 产品
    var cloth: MSClothModel?
    /// 库存匹数
    var stockRollCount: Int = 0
    /// 库存米数
    var stockMeterCount: Double = 0
    /// 是否正在编辑
    var isEditing: Bool?
    /// 是否已选中
    var isSelected: Bool?
}
