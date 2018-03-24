//
//  OrdersOrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class ActiveOrdersViewController: UIViewController, ActiveOrdersViewInput {
    
    @IBOutlet weak var tableView: UITableView!
    
    var output: ActiveOrdersViewOutput!
    var displayManager: ActiveOrdersDisplayManager!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }

    
    // MARK: OrdersViewInput
    func setupInitialState() {
        displayManager.setTableView(tableView: tableView)
    }
}
