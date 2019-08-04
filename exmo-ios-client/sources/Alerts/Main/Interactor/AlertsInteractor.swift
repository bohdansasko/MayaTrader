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
    var isViewActive = false

    deinit {
        print("deinit \(String(describing: self))")
        unsubscribeFromNotifications()
    }
}

// MARK: AlertsInteractorInput
extension AlertsInteractor: AlertsInteractorInput {
    func viewIsReady() {
        subscribeOnVinsoAPIEvents()
        subscribeOnIAPNotifications()
    }

    func viewDidAppear() {
        isViewActive = true
        if AppDelegate.vinsoAPI.isAuthorized {
            loadAlerts()
        } else {
            AppDelegate.vinsoAPI.establishConnection()
        }
    }

    func viewWillDisappear() {
        isViewActive = false
    }

    func loadAlerts() {
        print("\(String(describing: self)) => \(#function)")
        AppDelegate.vinsoAPI.loadAlerts()
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

// MARK: VinsoAPIConnectionDelegate
extension AlertsInteractor: VinsoAPIConnectionDelegate {
    func onAuthorization() {
        loadAlerts()
    }
    
    func onConnectionRefused(reason: String) {
        if isViewActive {
            output.onDidLoadAlertsHistory([])
            output.onConnectionRefused(reason: reason)
        }
    }
}

// MARK: AlertsAPIResponseDelegate
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

// MARK: subscriptions
extension AlertsInteractor {
    func subscribeOnVinsoAPIEvents() {
        AppDelegate.vinsoAPI.addConnectionObserver(self)
        AppDelegate.vinsoAPI.addAlertsObserver(self)
    }

    func subscribeOnIAPNotifications() {
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPService.Notification.updateSubscription.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onPurchaseError(_ :)),
                name: IAPService.Notification.purchaseError.name)
    }

    func unsubscribeFromNotifications() {
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
            output.onPurchaseError(msg: "Purchase: Undefined error")
            return
        }
        output.onPurchaseError(msg: errorMsg)
    }
}
