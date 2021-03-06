//
//  AlertsAlertsViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

protocol AlertsViewInput: class {
    func update(_ alerts: [Alert])

    func updateAlert(_ alert: Alert)
    func deleteAlerts(withIds ids: [Int])

    func setSubscription(_ package: CHSubscriptionPackageProtocol)
    func showAlert(msg: String)
}

protocol AlertsViewOutput: class {
    func viewIsReady()
    func viewDidAppear()
    func viewWillDisappear()

    func showFormCreateAlert()

    func editAlert(_ alert: Alert)
    func updateAlertState(_ alert: Alert)
    func deleteAlert(withId id: Int)
    func deleteAlerts(ids: [Int])
}
