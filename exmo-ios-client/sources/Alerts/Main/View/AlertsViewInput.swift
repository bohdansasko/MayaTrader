//
//  AlertsAlertsViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

protocol AlertsViewInput: class {
    func setupInitialState()
    func showPlaceholderNoData()
    func removePlaceholderNoData()
}

protocol AlertsViewOutput {
    func viewIsReady()
    func showEditView(data: AlertItem)
    func prepareSegue(viewController: UIViewController, data: Any?)
}
