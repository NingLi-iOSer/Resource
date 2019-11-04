//
//  ViewController.swift
//  3DTouch
//
//  Created by Ning Li on 2019/3/27.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var sureDeleteLabel: UILabel = {
        let label = UILabel()
        label.text = "确认删除"
        label.backgroundColor = UIColor(red: 255 / 255.0, green: 56 / 255.0, blue: 50 / 255.0, alpha: 1)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var data: [String] = {
        var temp = [String]()
        for i in 0..<20 {
            temp.append(i.description)
        }
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 60
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available { // 3DTouch
            registerForPreviewing(with: self, sourceView: cell)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "删除") { [unowned self] (_, sourceView, _) in
            if (self.sureDeleteLabel.superview != nil) { // 确认删除已显示
                print("确认删除")
            } else {
                var rootView: UIView? = nil
                if sourceView is UILabel {
                    rootView = sourceView.superview?.superview
                    self.sureDeleteLabel.font = (sourceView as! UILabel).font
                }
                self.sureDeleteLabel.frame = CGRect(origin: CGPoint(x: sourceView.bounds.width, y: 0),
                                                    size: sourceView.bounds.size)
                rootView?.addSubview(self.sureDeleteLabel)
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.sureDeleteLabel.frame.origin.x = 0
                    self.sureDeleteLabel.frame.size.width = rootView!.bounds.width
                }, completion: nil)
            }
        }
        
        let remarkAction = UIContextualAction(style: .normal, title: "备注") { (_, _, _) in
            if (self.sureDeleteLabel.superview != nil) { // 确认删除已显示
                print("确认删除")
            }
        }
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction, remarkAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

extension ViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let vc = TargetController()
        previewingContext.sourceRect = CGRect(origin: CGPoint(), size: CGSize(width: view.bounds.width, height: 60))
        return vc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
    }
}
