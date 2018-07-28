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

    func viewIsReady() {
       // do nothing
    }
    
    func showEditView(data: AlertItem) {
        let view = self.view as! UIViewController
        self.router.showEditView(view: view, data: data)
    }
    
    func prepareSegue(viewController: UIViewController, data: Any?) {
        guard let createAlertNavController = viewController as? UINavigationController else {
            print("AlertsPresenter: can't cast view controller in create alert view controller")
            return
        }
        guard let createAlertViewController = createAlertNavController.viewControllers.first as? CreateAlertViewController else {
            print("AlertsPresenter: can't cast view controller in create alert view controller")
            return
        }
        
        if let alertItem = data as? AlertItem {
            if let createAlertPresenter = createAlertViewController.output as? CreateAlertModuleInput {
                 createAlertPresenter.setAlertData(alertItem: alertItem)
            }
        }
    }
}
