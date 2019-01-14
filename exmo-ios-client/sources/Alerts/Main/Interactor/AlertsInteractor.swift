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

        let shouldShowAds = !IAPService.shared.isProductPurchased(.advertisements)
        output.setAdsVisible(shouldShowAds)
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
                selector: #selector(onProductPurchased(_ :)),
                name: IAPService.Notification.purchased.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductExpired(_ :)),
                name: IAPService.Notification.expired.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductNotPurchased(_ :)),
                name: IAPService.Notification.notPurchased.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseSuccess(_ :)),
                name: IAPService.Notification.purchaseSuccess.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseError(_ :)),
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
    func onProductPurchased(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)) => notification IAPProduct is \(product.rawValue)")
        onProductActive(product)
    }
    
    @objc
    func onProductExpired(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        onProductInactive(product)
    }
    
    @objc
    func onProductNotPurchased(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        onProductInactive(product)
    }

    @objc
    func onProductPurchaseSuccess(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        onProductActive(product)
    }

    @objc
    func onProductPurchaseError(_ notification: Notification) {
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
        onProductInactive(product)
    }

    private func onProductActive(_ product: IAPProduct) {
        switch product {
        case .advertisements: output.setAdsVisible(false)
        case .litePackage: break
        case .proPackage: break
        }
    }

    private func onProductInactive(_ product: IAPProduct) {
        switch product {
        case .advertisements: output.setAdsVisible(true)
        case .litePackage: break
        case .proPackage: break
        }
    }
}
