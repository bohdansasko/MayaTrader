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
    
    override init() {
        super.init()
        self.ordersDataProvider = Session.sharedInstance.getOrders()
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
    
    func getOrderTypeIdAsStrBy(orderType: OrderType) -> String {
        switch orderType {
        case .Buy:
            return TableCellIdentifiers.OrdersBuyTableViewCell.rawValue
        case .Sell:
            return TableCellIdentifiers.OrdersSellTableViewCell.rawValue
        case .None:
            return "None"
        }
    }
}


extension OrdersDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ordersDataProvider.getCountOrders()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderData = self.ordersDataProvider.getOrderBy(index: indexPath.row)
        let cellId = getOrderTypeIdAsStrBy(orderType: orderData.getOrderType())
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderTableViewCell
        cell.setContent(orderData: orderData)
        
        return cell
    }
}
