//
//  CHBaseForm.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

/*
 presenter
     -> table
     -> form
         -> hilo(xib)
         -> hi(xib)
         -> low(xib)
 */

class CHBaseForm: NSObject {
    let tableView: UITableView
    
    var cells     = [IndexPath: UITableViewCell]()
    var formItems = [IndexPath: FormItem]()
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
}
