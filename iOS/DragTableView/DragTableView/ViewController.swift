//
//  ViewController.swift
//  DragTableView
//
//  Created by Ning Li on 2019/1/22.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var tableView = UITableView(frame: CGRect(), style: .plain)
    
    private lazy var numbers: [String] = {
        var temp = [String]()
        for index in 0..<20 {
            temp.append(index.description)
        }
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = CGRect(x: 0, y: 400, width: 375, height: 667)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.rowHeight = 44
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dragTableView(pan:)))
        tableView.addGestureRecognizer(pan)
        pan.delegate = self
    }

    @objc private func dragTableView(pan: UIPanGestureRecognizer) {
        let offsetY = pan.translation(in: tableView).y
        if tableView.frame.minY <= 0 && offsetY <= 0 {
            tableView.frame.origin.y = 0
            pan.setTranslation(CGPoint.zero, in: view)
            return
        } else if (view.bounds.height - tableView.frame.minY <= 300) && offsetY >= 0 {
            tableView.frame.origin.y = view.bounds.height - 300
            pan.setTranslation(CGPoint.zero, in: view)
            return
        }
        
        if tableView.contentOffset.y <= 0 || tableView.frame.minY > 0 {
            tableView.frame.origin.y += offsetY
            tableView.contentOffset = CGPoint.zero
        }
        pan.setTranslation(CGPoint.zero, in: view)
        
        switch pan.state {
        case .ended, .cancelled, .failed, .possible:
            if tableView.frame.minY <= view.bounds.height * 0.3 {
                UIView.animate(withDuration: 0.25) {
                    self.tableView.frame.origin.y = 0
                }
            } else {
                UIView.animate(withDuration: 0.25) {
                    self.tableView.frame.origin.y = self.view.bounds.height - 300
                }
            }
        default:
            break
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = numbers[indexPath.row]
        return cell
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
