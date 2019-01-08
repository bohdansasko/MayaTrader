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
}

extension AlertsInteractor: AlertsInteractorInput {
    func viewIsReady() {
        AppDelegate.vinsoAPI.connectionDelegate = self
        AppDelegate.vinsoAPI.alertsDelegate = self

        let alerts = [
            Alert(id: 0, currencyPairName: "BTC_USD", priceAtCreateMoment: 3800, description: "Fucking people @GKarlin", topBoundary: 4000, bottomBoundary: 3700, isPersistentNotification: true),
            Alert(id: 0, currencyPairName: "XRP_USD", priceAtCreateMoment: 0.35, description: "People fucked @GKarlin", topBoundary: 0.5, bottomBoundary: 0.3, isPersistentNotification: false)
        ]
        alerts.forEach({
            AppDelegate.vinsoAPI.createAlert(alert: $0)
        })
    }

    func viewDidAppear() {
        if AppDelegate.vinsoAPI.isConnectionOpen() {
            onConnectionOpened()
        } else {
            AppDelegate.vinsoAPI.connect()
        }
    }

    func updateAlertState(_ alert: Alert) {
        AppDelegate.vinsoAPI.updateAlert(alert)
    }

    func deleteAlert(withId id: Int) {
        AppDelegate.vinsoAPI.deleteAlert(withId: id)
    }
}

extension AlertsInteractor: IAlertsNetworkWorkerDelegate {
    func onDidLoadAlertsHistorySuccessful(_ w: ExmoWallet) {
        print("AlertsInteractor => loaded alerts history")
    }

    func onDidLoadAlertsHistoryFail(messageError: String) {
        print(messageError)
    }
}

extension AlertsInteractor: VinsoAPIConnectionDelegate {
    func onConnectionOpened() {
        print("AlertsInteractor => onConnectionOpened")
        AppDelegate.vinsoAPI.login()
    }
    
    func onLogined() {
        print("AlertsInteractor => onLogined")
        AppDelegate.vinsoAPI.loadAlerts()
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

    func onDidDeleteAlertSuccessful(withId id: Int) {
        output.deleteAlertSuccessful(withId: id)
    }

}
