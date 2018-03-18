//
//  AlertsAlertsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class AlertsViewController: UIViewController, AlertsViewInput {

    @IBOutlet weak var tableView: UITableView!
    
    var output: AlertsViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady(tableView: tableView)
    }


    // MARK: AlertsViewInput
    func setupInitialState() {
    }
}
