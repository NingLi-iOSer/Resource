//
//  LNFooterCell.swift
//  Test
//
//  Created by Ning Li on 2019/9/29.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class LNFooterCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        clipsToBounds = true
        backgroundColor = UIColor.systemGroupedBackground
        
        let topShapeLayer = CAShapeLayer()
        topShapeLayer.fillColor = UIColor.white.cgColor
        let topPath = UIBezierPath(roundedRect: CGRect(x: 0, y: -12, width: UIScreen.main.bounds.width, height: 24), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 12, height: 12))
        topShapeLayer.path = topPath.cgPath
        layer.addSublayer(topShapeLayer)

        let bottomShapeLayer = CAShapeLayer()
        bottomShapeLayer.fillColor = UIColor.white.cgColor
        let bottomPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 22, width: UIScreen.main.bounds.width, height: 24), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
        bottomShapeLayer.path = bottomPath.cgPath
        layer.addSublayer(bottomShapeLayer)
    }
}
