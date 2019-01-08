//
//  AlertsAlertsPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

class AlertsPresenter {
    weak var view: AlertsViewInput!
    var interactor: AlertsInteractorInput!
    var router: AlertsRouterInput!
}

extension AlertsPresenter: AlertsViewOutput {
    func viewIsReady() {
       interactor.viewIsReady()
    }
    
    func viewDidAppear() {
        interactor.viewDidAppear()
    }

    func showFormCreateAlert() {
        router.showVCAddAlert(view as! UIViewController)
    }

    func editAlert(_ alert: Alert) {
        let view = self.view as! UIViewController
        router.editAlert(view: view, alert: alert)
    }

    func updateAlertState(_ alert: Alert) {
        interactor.updateAlertState(alert)
    }

    func deleteAlert(withId id: Int) {
        interactor.deleteAlert(withId: id)
    }
}

extension AlertsPresenter: AlertsInteractorOutput {
    func onDidLoadAlertsHistory(_ alerts: [Alert]) {
        view.update(alerts)
    }

    func updateAlertSuccessful(_ alert: Alert) {
        view.updateAlert(alert)
    }

    func deleteAlertSuccessful(withId id: Int) {
        view.deleteAlert(withId: id)
    }
}
