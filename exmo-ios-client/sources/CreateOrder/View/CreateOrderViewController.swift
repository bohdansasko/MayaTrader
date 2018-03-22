//
//  CreateOrderCreateOrderViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderViewController: UIViewController, CreateOrderViewInput {

    var output: CreateOrderViewOutput!
    var dataDisplayManager: CreateOrderDisplayManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }


    // MARK: CreateOrderViewInput
    func setupInitialState() {
        dataDisplayManager.setTableView(tableView: tableView)
    }
}
