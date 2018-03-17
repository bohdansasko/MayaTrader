//
//  AlertsAlertsRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class AlertsRouter: AlertsRouterInput {
    func showEditView(view: UIViewController, data: AlertItem)  {
        view.openModule(segueIdentifier: AlertsIdentifiers.EditAlert.rawValue, block: nil)
    }
}
