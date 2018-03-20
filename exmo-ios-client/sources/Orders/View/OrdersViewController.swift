//
//  OrdersOrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController, OrdersViewInput {
    
    @IBOutlet weak var tableView: UITableView!
    
    var output: OrdersViewOutput!
    var displayManager: OrdersDisplayManager!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayManager = OrdersDisplayManager()
        displayManager.setTableView(tableView: tableView)
    }


    // MARK: OrdersViewInput
    func setupInitialState() {
        // do nothing
    }
}
