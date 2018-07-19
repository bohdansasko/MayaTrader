//
//  AlertsAlertsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class AlertsViewController: ExmoUIViewController, AlertsViewInput {
    
    @IBOutlet weak var tableView: UITableView!
    
    var output: AlertsViewOutput!
    var displayManager: AlertDataDisplayManager!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppendAlert), name: .AppendAlert, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onAppendAlert(notification: NSNotification) {
        guard let alertItem = notification.userInfo?["alertData"] as? AlertItem else {
            print("Can't convert to AlertItem")
            return
        }
        self.displayManager.appendAlert(alertItem: alertItem)
    }

    // MARK: AlertsViewInput
    func setupInitialState() {
        self.displayManager.setTableView(tableView: self.tableView)
    }
}
