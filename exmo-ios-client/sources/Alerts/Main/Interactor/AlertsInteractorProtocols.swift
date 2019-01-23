//
//  AlertsAlertsInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol AlertsInteractorInput {
    func viewIsReady()
    func viewDidAppear()

    func updateAlertState(_ alert: Alert)
    func deleteAlert(withId id: Int)
    func deleteAlerts(ids: [Int])
}

protocol AlertsInteractorOutput: class {
    func onDidLoadAlertsHistory(_ alerts: [Alert])
    func updateAlertSuccessful(_ alert: Alert)
    func deleteAlertsSuccessful(ids: [Int])

    func setSubscription(_ package: ISubscriptionPackage)

    func onConnectionRefused(reason: String)
    func onPurchaseError(msg: String)
}
