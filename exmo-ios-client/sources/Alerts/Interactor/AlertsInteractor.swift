//
//  AlertsAlertsInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

class AlertsInteractor: AlertsInteractorInput {

    var displayManager: AlertDataDisplayManager
    weak var output: AlertsInteractorOutput!

    init() {
        displayManager = AlertDataDisplayManager()
        displayManager.interactor = self
    }

    func viewIsReady(tableView: UITableView!) {
        displayManager.setTableView(tableView: tableView)
    }

}
