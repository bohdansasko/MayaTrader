//
//  OrdersDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class OrdersDisplayManager: NSObject {
    var ordersDataProvider: OrdersModel!
    var tableView: UITableView!
    var shouldUseActions: Bool
    
    init(data: OrdersModel, shouldUseActions: Bool) {
        self.ordersDataProvider = data
        self.shouldUseActions = shouldUseActions

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
        return ordersDataProvider.isDataExists()
    }
}


extension OrdersDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ordersDataProvider.getCountOrders()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderData = self.ordersDataProvider.getOrderBy(index: indexPath.row)
        let cellId = TableCellIdentifiers.OrderTableViewCell.rawValue
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderTableViewCell
        cell.setContent(orderData: orderData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if !self.shouldUseActions {
            return []
        }
        
        let deleteAction = UITableViewRowAction.init(style: .normal, title: "Delete", handler: { action, indexPath in
            print("called delete action")
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
}
