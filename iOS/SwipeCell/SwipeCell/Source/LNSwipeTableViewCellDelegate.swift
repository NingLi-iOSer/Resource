//
//  LNSwipeTableViewCellDelegate.swift
//  SwipeCell
//
//  Created by Ning Li on 2019/9/28.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import UIKit

protocol LNSwipeTableViewCellDelegate: class {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [LNSwipeAction]?
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath) -> LNSwipeOptions
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath)
    
    func visibleRect(for tableView: UITableView) -> CGRect?
}

extension LNSwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath) -> LNSwipeOptions {
        return LNSwipeOptions()
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) { }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath) { }
    
    func visibleRect(for tableView: UITableView) -> CGRect? {
        return nil
    }
}
