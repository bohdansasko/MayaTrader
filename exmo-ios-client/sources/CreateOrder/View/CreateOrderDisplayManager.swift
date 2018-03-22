//
//  CreateOrderDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/22/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class CreateOrderDisplayManager: NSObject {
    var tableView: UITableView!
    var output: CreateOrderViewOutput!
    var cell: CreateOrderTableViewCell? = nil
    
    override init() {
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
    
    func createOrderPressed() {
        if self.cell != nil {
            guard let model = self.cell?.getOrderModel() else { return }
            self.output.createOrder(orderModel: model)
        }
    }
}


extension CreateOrderDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersSegueIdentifiers
.CreateOrder.rawValue, for: indexPath) as! CreateOrderTableViewCell
        self.cell = cell
        
        self.cell?.setOnCreateOrderCallback() {
            self.createOrderPressed()
        }
        
        return cell
    }
}
