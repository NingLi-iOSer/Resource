//
//  MSInventoryListCell.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/7/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

let kInventoryListCellRowHeight: CGFloat = 104
let kInventoryListCellId = "kInventoryListCellId"

protocol MSInventoryListCellDelegate: class {
    /// 长按 cell 回调
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - index: cell 索引
    func cell(_ cell: MSInventoryListCell, longPressFor index: Int)
}

/// 库存清单 cell
class MSInventoryListCell: MSSelectedCell {

    private weak var delegate: MSInventoryListCellDelegate?
    
    /// cell 索引
    var index: Int = 0
    
    private var model: MSInventoryModel?
    
    /// 图片
    @IBOutlet weak var pictureView: MSCustomImageView!
    /// 图片左侧约束
    @IBOutlet weak var pictureViewLeftCons: NSLayoutConstraint!
    /// 产品编号
    @IBOutlet weak var storeNameLabel: UILabel!
    /// 匹数
    @IBOutlet weak var rollCount: UILabel!
    /// 米数
    @IBOutlet weak var meterLabel: UILabel!
    /// 选择按钮
    @IBOutlet weak var selectButton: UIButton!
    /// 无库存提示图标
    @IBOutlet weak var noInventoryIconView: UIImageView!
    
    func set(_ model: MSInventoryModel, delegate: MSInventoryListCellDelegate?) {
        self.model = model
        self.delegate = delegate
        storeNameLabel.text = model.cloth?.code
        rollCount.text = model.stockRollCount.description
        meterLabel.text = model.stockMeterCount.ignoreDecimalZero
        
        noInventoryIconView.isHidden = (model.stockRollCount != 0)
        selectButton.isSelected = (model.isSelected == true)
        
        if (model.isEditing == true) {
            if selectButton.isHidden {
                selectButton.isHidden = false
                pictureViewLeftCons.constant = 40
            }
        } else {
            if !selectButton.isHidden {
                pictureViewLeftCons.constant = 15
                selectButton.isHidden = true
            }
        }
        
        pictureView.ms_setImage(with: model.cloth?.imageList?.first?.thumb200, placeholder: #imageLiteral(resourceName: "img-jiazai"), failure: #imageLiteral(resourceName: "tupianjiazaishibai"), empty: #imageLiteral(resourceName: "img-no-pictures"))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pictureView.delegate = self
        
        // 添加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognize(longPress:)))
        addGestureRecognizer(longPress)
    }
}

// MARK: - 监听事件
extension MSInventoryListCell {
    /// 长按手势监听事件
    @objc private func longPressRecognize(longPress: UILongPressGestureRecognizer) {
        if model?.isEditing == true { // 正在编辑, 返回
            return
        }
        switch longPress.state {
        case .began:
            model?.isSelected = true
            delegate?.cell(self, longPressFor: index)
        default:
            break
        }
    }
}

// MARK: - MSCustomImageViewDelegate
extension MSInventoryListCell: MSCustomImageViewDelegate {
    func imageViewDidTouch(_ imageView: MSCustomImageView) {
        if let images = model?.cloth?.imageList {
            let info: [String: Any] = ["sourceView": imageView,
                                       "images": images]
            NotificationCenter.default.post(name: NSNotification.Name(kBrowserImagesNorification), object: info)
        } else {
            MSHUD.show(message: "暂无图片")
        }
    }
}
