//
//  DealsOrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class DealsOrdersViewController: UIViewController, DealsOrdersViewInput {

    @IBOutlet weak var tableView: UITableView!
    
    var output: DealsOrdersViewOutput!
    var displayManager: OrdersDisplayManager!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }
    
    
    // MARK: OrdersViewInput
    func setupInitialState() {
        displayManager.setTableView(tableView: self.tableView)
    }
}
