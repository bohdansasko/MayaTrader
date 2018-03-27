//
//  WatchlistCurrencyPairModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

import Foundation
import UIKit

class WatchlistFlatDisplayManager: NSObject {
    private var dataProvider: WatchlistCurrencyPairsModel!
    var tableView: UITableView!
    
    init(data: WatchlistCurrencyPairsModel) {
        self.dataProvider = data
        
        super.init()
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return dataProvider.isDataExists()
    }
}


extension WatchlistFlatDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.getCountOrders()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderData = self.dataProvider.getOrderBy(index: indexPath.row)
        let cellId = TableCellIdentifiers.WatchlistTableViewCell.rawValue
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WatchlistFlatTableViewCell
         cell.setContent(data: orderData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .normal, title: "Delete", handler: { action, indexPath in
            print("called delete action")
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
}
