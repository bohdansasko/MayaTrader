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
        log.debug()
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
        }
    }

    func viewWillDisappear() {
        isViewActive = false
    }

    func loadAlerts() {
        AppDelegate.vinsoAPI.loadAlerts()
    }

    func updateAlertState(_ alert: Alert) {
//        AppDelegate.vinsoAPI.updateAlert(alert)
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
        log.info("AlertsInteractor => loaded alerts history")
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
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPNotification.updateSubscription)
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onPurchaseError(_ :)),
                name: IAPNotification.purchaseError)
    }

    func unsubscribeFromNotifications() {
        AppDelegate.vinsoAPI.removeConnectionObserver(self)
        AppDelegate.vinsoAPI.removeAlertsObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
}

extension AlertsInteractor {
    
    @objc func onProductSubscriptionActive(_ notification: Notification) {
        log.debug(notification.name)
        guard let CHSubscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? CHSubscriptionPackageProtocol else {
            log.error("\(#function) => can't convert notification container to CHSubscriptionPackageProtocol")
            output.setSubscription(CHBasicAdsSubscriptionPackage())
            return
        }
        output.setSubscription(CHSubscriptionPackage)
    }

    @objc func onPurchaseError(_ notification: Notification) {
        log.debug(notification.name)
        guard let errorMsg = notification.userInfo?[IAPService.kErrorKey] as? String else {
            log.error("\(#function) => can't cast error message to String")
            output.onPurchaseError(msg: "Purchase: Undefined error")
            return
        }
        output.onPurchaseError(msg: errorMsg)
    }
}
