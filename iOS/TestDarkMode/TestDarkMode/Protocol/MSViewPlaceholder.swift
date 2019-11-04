//
//  MSViewPlaceholder.swift
//  ManagementSystem
//
//  Created by Ning Li on 2018/11/12.
//  Copyright © 2018 Apple. All rights reserved.
//

let kViewPlaceholderTag: Int = 1001

protocol MSViewPlaceholder {
    
    /// 添加缺省视图
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - detail: 详情信息
    func addPlaceholderView(image: UIImage?, title: String?, detail: String?)
    
    func addPlaceholderView(image: UIImage?, title: String?, detail: String?, offset: CGFloat)
    
    /// 隐藏缺省视图
    ///
    /// - Parameter isHidden: 是否隐藏
    func hiddenPlaceholderView(_ isHidden: Bool)
}

extension MSViewPlaceholder where Self: UIView {
    func addPlaceholderView(image: UIImage?, title: String?, detail: String?) {
        addPlaceholderView(image: image, title: title, detail: detail, offset: 120)
    }
    
    func addPlaceholderView(image: UIImage?, title: String?, detail: String?, offset: CGFloat) {
        if let v = viewWithTag(kViewPlaceholderTag) as? MSNoDataView {
            v.isHidden = false
            return
        }
        /// 缺省视图
        let noDataView: MSNoDataView
        if image == nil {
            noDataView = MSNoDataView(title: title, subTitle: detail)
        } else {
            noDataView = MSNoDataView(image: image!, title: title, subTitle: detail)
        }
        noDataView.tag = kViewPlaceholderTag
        addSubview(noDataView)
        noDataView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(offset)
            make.centerX.equalToSuperview()
            make.width.equalTo(self)
            make.left.right.equalToSuperview()
            make.height.equalTo(240)
        }
    }
    
    func updatePlaceholderView(image: UIImage?, title: String?, detail: String?) {
        guard let v = viewWithTag(kViewPlaceholderTag) as? MSNoDataView else {
            return
        }
        v.setContent(image: image, title: title, subTitle: detail)
    }
    
    /// 设置空列表占位
    ///
    /// - Parameter title: 提示信息
    func settingEmptyPlaceholder(title: String?) {
        guard let v = viewWithTag(kViewPlaceholderTag) as? MSNoDataView else {
            addPlaceholderView(image: #imageLiteral(resourceName: "img-kong"), title: title, detail: nil)
            return
        }
        v.setContent(image: #imageLiteral(resourceName: "img-kong"), title: title, subTitle: nil)
    }
    
    /// 设置无搜索结果占位
    func settingNoResultPlaceholder() {
        guard let v = viewWithTag(kViewPlaceholderTag) as? MSNoDataView else {
            return
        }
        v.setContent(image: #imageLiteral(resourceName: "img-sousuo"), title: "暂无搜索结果", subTitle: nil)
    }
    
    func hiddenPlaceholderView(_ isHidden: Bool) {
        let v = viewWithTag(kViewPlaceholderTag)
        v?.isHidden = isHidden
    }
}
