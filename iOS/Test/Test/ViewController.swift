//
//  ViewController.swift
//  Test
//
//  Created by Ning Li on 2019/7/12.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var data = [[Int]]()
    
    private var randomColor: UIColor {
        let value1 = CGFloat(arc4random_uniform(256))
        let value2 = CGFloat(arc4random_uniform(256))
        let value3 = CGFloat(arc4random_uniform(256))
        let color = UIColor(red: value1 / 255.0, green: value2 / 255.0, blue: value3 / 255.0, alpha: 1)
        return color
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<5 {
            var temp = [Int]()
            for index in 0..<5 {
                temp.append(index)
            }
            data.append(temp)
        }
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(LNFooterCell.self, forCellReuseIdentifier: "LNFooterCellId")
        tableView.contentInset.top = 22
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == data[indexPath.section].count - 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LNFooterCellId", for: indexPath) as! LNFooterCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
            cell.backgroundColor = randomColor
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == data[indexPath.section].count - 1 {
            if indexPath.section == data.count - 1 {
                return 22
            } else {
                return 34
            }
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let isFirst = section == 0
        let v = LNHeaderView.instance(title: "header - \(section)", isFirst: isFirst)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
