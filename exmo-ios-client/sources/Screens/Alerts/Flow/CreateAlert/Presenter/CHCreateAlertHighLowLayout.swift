//
//  CHCreateAlertHighLowLayout.swift
//  exmo-ios-client
//
//  Created by Office Mac on 9/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

/*
 presenter
 -> table
 -> layout
     -> hilo(xib)
     -> hi(xib)
     -> low(xib)
 */

protocol CHCreateAlertLayoutProtocol {
    associatedtype TableViewCell
    var tableViewCellType: TableViewCell.Type { get }
}

class CHCreateAlertLayout: NSObject, CHCreateAlertLayoutProtocol {
    typealias TableViewCell = UITableViewCell
    
    var tableViewCellType: UITableViewCell.Type {
        return UITableViewCell.self
    }
    
    private var cells: [IndexPath: UITableViewCell] = [:]
    private var items: [String] = ["", ""]
}

extension CHCreateAlertLayout: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells.keys.contains(indexPath) {
            return cells[indexPath]!
        }
        
        let cell = tableView.dequeue(class: tableViewCellType, for: indexPath)
        cells[indexPath] = cell
        return cell
    }
    
}

final class CHCreateAlertHighLowLayout: CHCreateAlertLayout {
    
}
