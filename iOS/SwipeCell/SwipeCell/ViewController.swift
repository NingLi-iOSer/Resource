//
//  ViewController.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/25.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

enum ButtonStyle {
    case backgroundColor
    case circular
}

class ViewController: UIViewController {
    
    private lazy var data = [String]()
    private var defaultOptions = LNSwipeOptions()
    private var buttonStyle = ButtonStyle.backgroundColor

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TestCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 80
        
        for index in 0..<20 {
            data.append("\(index)")
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TestCell
        cell.textLabel?.text = data[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension ViewController: LNSwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [LNSwipeAction]? {
        let edit = LNSwipeAction(style: .default, title: "编辑") { (action, indexPath) in
            print(indexPath.row)
        }
        edit.image = #imageLiteral(resourceName: "Group7")
        edit.backgroundColor = UIColor.systemGroupedBackground
        edit.textColor = UIColor.gray
        let delete = LNSwipeAction(style: .destructive, title: "删除") { (action, indexPath) in
            print(indexPath.row)
        }
        delete.image = #imageLiteral(resourceName: "Group2")
        delete.backgroundColor = UIColor.systemGroupedBackground
        delete.textColor = UIColor.gray
        return [edit, delete]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath) -> LNSwipeOptions {
        var options = LNSwipeOptions()
        options.expansionsStyle = .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 4
        case .circular:
            options.buttonSpacing = 4
        }
        return options
    }
}

class TestCell: LNSwipeCell {
    
    var animator: Any?
    
}
