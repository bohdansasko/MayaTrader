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
        AppDelegate.vinsoAPI.removeConnectionObserver(self)
        AppDelegate.vinsoAPI.removeAlertsObserver(self)
    }
}

extension AlertsInteractor: AlertsInteractorInput {
    func viewIsReady() {
        AppDelegate.vinsoAPI.addConnectionObserver(self)
        AppDelegate.vinsoAPI.addAlertsObserver(self)
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

    func onDidDeleteAlertSuccessful(withId id: Int) {
        output.deleteAlertSuccessful(withId: id)
    }

}
