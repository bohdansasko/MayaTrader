//
//  AlertsAlertsPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

class AlertsPresenter: AlertsModuleInput, AlertsViewOutput, AlertsInteractorOutput {

    weak var view: AlertsViewInput!
    var interactor: AlertsInteractorInput!
    var router: AlertsRouterInput!

    func viewIsReady(tableView: UITableView!) {
        interactor.viewIsReady(tableView: tableView)
    }
    
    func showEditView(data: AlertItem) {
        let view = self.view as! UIViewController
        router.showEditView(view: view, data: data)
    }
}
