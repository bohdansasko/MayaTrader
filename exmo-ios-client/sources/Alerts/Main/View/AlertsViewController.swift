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
    private var placeholderNoData: PlaceholderNoDataView = {
        let view = PlaceholderNoDataView()
        view.text = "You haven't alerts right now"
        view.isHidden = true
        return view
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
        setupPlaceholderNoData()
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.output.prepareSegue(viewController: segue.destination, data: sender)
    }
    
    // MARK: AlertsViewInput
    func setupInitialState() {
        self.displayManager.setTableView(tableView: self.tableView)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onAppendAlert), name: .AppendAlert)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUpdateAlert), name: .UpdateAlert)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onDeleteAlert), name: .DeleteAlert)
    }

    private func setupPlaceholderNoData() {
        view.addSubview(placeholderNoData)
        let topOffset: CGFloat = AppDelegate.isIPhone(model: .Five) ? 35 : 90
        placeholderNoData.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func showPlaceholderNoData() {
        placeholderNoData.isHidden = false
    }
    
    func removePlaceholderNoData() {
        placeholderNoData.isHidden = true
    }
    
    // MARK: actions
    @objc func onAppendAlert(notification: NSNotification) {
        guard let alertItem = notification.userInfo?["alertData"] as? AlertItem else {
            print("Can't convert to AlertItem")
            return
        }
        self.displayManager.appendAlert(alertItem: alertItem)
    }
    
    @objc func onUpdateAlert(notification: NSNotification) {
        guard let alertItem = notification.userInfo?["alertData"] as? AlertItem else {
            print("Can't convert to AlertItem")
            return
        }
        self.displayManager.updateAlert(alertItem: alertItem)
    }

    @objc func onDeleteAlert(notification: NSNotification) {
        guard let alertId = notification.userInfo?["alertData"] as? String else {
            print("Can't convert to AlertItem")
            return
        }
        self.displayManager.deleteById(alertId: alertId)
    }

    
}
