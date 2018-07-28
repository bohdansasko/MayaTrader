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
    private var placeholderNoData: PlaceholderNoDataView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.output.prepareSegue(viewController: segue.destination, data: sender)
    }
    
    // MARK: AlertsViewInput
    func setupInitialState() {
        self.displayManager.setTableView(tableView: self.tableView)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onAppendAlert), name: .AppendAlert, object: nil)
    }

    func showPlaceholderNoData() {
        if placeholderNoData != nil {
            print("placeholder no data already exists")
            return
        }
        print("show placeholder no data")
        
        self.placeholderNoData = PlaceholderNoDataView(frame: self.view.bounds)
        self.placeholderNoData.setDescriptionType(descriptionType: .Alerts)
        self.placeholderNoData?.frame = self.view.bounds
        self.view.addSubview(self.placeholderNoData!)
        self.placeholderNoData?.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 140)
    }
    
    func removePlaceholderNoData() {
        if self.placeholderNoData != nil {
            self.placeholderNoData?.removeFromSuperview()
            self.placeholderNoData = nil
        }
    }
    
    // MARK: actions
    @objc func onAppendAlert(notification: NSNotification) {
        guard let alertItem = notification.userInfo?["alertData"] as? AlertItem else {
            print("Can't convert to AlertItem")
            return
        }
        self.displayManager.appendAlert(alertItem: alertItem)
    }
}
