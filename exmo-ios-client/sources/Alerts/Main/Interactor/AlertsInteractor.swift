//
//  AlertsAlertsInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

class AlertsInteractor  {
    weak var output: AlertsInteractorOutput!

    deinit {
        print("deinit \(String(describing: self))")
        unsubscribeEvents()
    }
}

extension AlertsInteractor: AlertsInteractorInput {
    func viewIsReady() {
        subscribeOnVinsoAPIEvents()
        subscribeOnIAPEvents()
    }

    func viewDidAppear() {
        if AppDelegate.vinsoAPI.isLogined {
            loadAlerts()
        } else {
            AppDelegate.vinsoAPI.establishConnect()
        }
    }

    func updateAlertState(_ alert: Alert) {
        AppDelegate.vinsoAPI.updateAlert(alert)
    }

    func deleteAlert(withId id: Int) {
        AppDelegate.vinsoAPI.deleteAlert(withId: id)
    }

    func deleteAlerts(ids: [Int]) {
        if !ids.isEmpty {
            AppDelegate.vinsoAPI.deleteAlerts(withId: ids)
        }
    }
}

extension AlertsInteractor: VinsoAPIConnectionDelegate {
    func loadAlerts() {
        print("AlertsInteractor => loadAlerts")
        AppDelegate.vinsoAPI.loadAlerts()
    }

    func onConnectionRefused() {
        output.onDidLoadAlertsHistory([])
    }
}

extension AlertsInteractor: AlertsAPIResponseDelegate {
    func onDidLoadAlertsHistorySuccessful(_ alerts: [Alert]) {
        print("AlertsInteractor => loaded alerts history")
        output.onDidLoadAlertsHistory(alerts)
    }

    func onDidUpdateAlertSuccessful(_ alert: Alert) {
        output.updateAlertSuccessful(alert)
    }

    func onDidDeleteAlertsSuccessful(ids: [Int]) {
        output.deleteAlertsSuccessful(ids: ids)
    }
}

extension AlertsInteractor {
    func subscribeOnVinsoAPIEvents() {
        AppDelegate.vinsoAPI.addConnectionObserver(self)
        AppDelegate.vinsoAPI.addAlertsObserver(self)
    }

    func subscribeOnIAPEvents() {
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPService.Notification.updateSubscription.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPService.Notification.purchaseError.name)
    }

    func unsubscribeEvents() {
        AppDelegate.vinsoAPI.removeConnectionObserver(self)
        AppDelegate.vinsoAPI.removeAlertsObserver(self)
        AppDelegate.notificationController.removeObserver(self)
    }
}

extension AlertsInteractor {
    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let subscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? ISubscriptionPackage else {
            print("\(#function) => can't convert notification container to ISubscriptionPackage")
            output.setSubscription(BasicAdsSubscriptionPackage())
            return
        }
        output.setSubscription(subscriptionPackage)
    }

    @objc
    func onPurchaseError(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let errorMsg = notification.userInfo?[IAPService.kErrorKey] as? String else {
            print("\(#function) => can't cast error message to String")
            return
        }
        // TODO: show error message
    }
}
