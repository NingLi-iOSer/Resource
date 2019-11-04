//
//  MSPopoverTableView.swift
//  PopoverView
//
//  Created by Ning Li on 2019/8/27.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class MSPopoverTableView: UITableView {
    
    private lazy var actions = [MSPopoverAction]()
    private var complete: ((_ action: MSPopoverAction) -> Void)?

    convenience init(actions: [MSPopoverAction], frame: CGRect, complete: ((_ action: MSPopoverAction) -> Void)?) {
        self.init()
        self.actions = actions
        self.frame = frame
        self.complete = complete
        
        let rect = CGRect(origin: CGPoint(), size: frame.size)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 4)
        let roundCornerLayer = CAShapeLayer()
        roundCornerLayer.path = path.cgPath
        roundCornerLayer.frame = rect
        layer.mask = roundCornerLayer
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        settingUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settingUI()
    }
    
    private func settingUI() {
        dataSource = self
        delegate = self
        isScrollEnabled = false
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        register(MSPopoverViewCell.self, forCellReuseIdentifier: "MSPopoverViewCellId")
        clipsToBounds = true
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MSPopoverTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MSPopoverViewCellId", for: indexPath) as! MSPopoverViewCell
        cell.set(action: actions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return actions[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        complete?(action)
    }
}

class MSPopoverViewCell: UITableViewCell {
    
    private lazy var titleButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settingUI()
    }
    
    private func settingUI() {
        titleButton.titleEdgeInsets.left = 5
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        titleButton.isUserInteractionEnabled = false
        titleButton.setTitleColor(UIColor.gray, for: .normal)
        contentView.addSubview(titleButton)
        
        layoutMargins.left = 0
        separatorInset.left = 0
        
        let v = UIView()
        v.backgroundColor = UIColor.red
        selectedBackgroundView = v
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleButton.frame = contentView.bounds
    }
    
    func set(action: MSPopoverAction) {
        titleButton.setImage(action.image, for: .normal)
        titleButton.setTitle(action.title, for: .normal)
    }
}

struct MSPopoverAction {
    var title: String
    var image: UIImage?
    var height: CGFloat = 44
    var index: Int = 0
    
    init(title: String, image: UIImage?, height: CGFloat = 44, index: Int = 0) {
        self.title = title
        self.image = image
        self.height = height
        self.index = index
    }
}
