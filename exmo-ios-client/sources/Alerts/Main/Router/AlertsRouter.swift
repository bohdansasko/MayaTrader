//
//  AlertsAlertsRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class AlertsRouter: AlertsRouterInput {
    func editAlert(view: UIViewController, alert: Alert)  {
        print("edit alert = \(alert)")
//        view.openModule(segueIdentifier: AlertsSegueIdentifiers.AddEditAlert, block: alert)
    }
}
