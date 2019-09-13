//
//  CHCreateAlertLayout.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/13/19.
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
