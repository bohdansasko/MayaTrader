//
//  AlertsAlertsRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class AlertsRouter: AlertsRouterInput {
    func showVCAddAlert(_ vc: UIViewController)  {
        let moduleInit = CreateAlertModuleInitializer()
        vc.present(moduleInit.viewController, animated: true, completion: nil)
    }
    
    func editAlert(view: UIViewController, alert: Alert)  {
        let moduleInit = CreateAlertModuleInitializer()
        view.present(moduleInit.viewController, animated: true, completion: nil)
    }
}
