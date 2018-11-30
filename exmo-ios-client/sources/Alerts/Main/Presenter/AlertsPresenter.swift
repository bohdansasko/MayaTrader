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
       interactor.viewIsReady()
    }
    
    func editAlert(_ alert: Alert) {
        let view = self.view as! UIViewController
        self.router.editAlert(view: view, alert: alert)
    }
    
    func showFormCreateAlert() {
        router.showVCAddAlert(view as! UIViewController)
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
        
        if let alertItem = data as? Alert {
            if let createAlertPresenter = createAlertViewController.output as? CreateAlertModuleInput {
                 createAlertPresenter.setAlertData(alertItem: alertItem)
            }
        }
    }
}
