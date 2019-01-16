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
        if let ivc = view as? UIViewController {
            router.showVCAddAlert(ivc)
        }
    }

    func editAlert(_ alert: Alert) {
        if let ivc = view as? UIViewController {
            router.editAlert(view: ivc, alert: alert)
        }
    }

    func updateAlertState(_ alert: Alert) {
        interactor.updateAlertState(alert)
    }

    func deleteAlert(withId id: Int) {
        interactor.deleteAlert(withId: id)
    }

    func deleteAlerts(ids: [Int]) {
        interactor.deleteAlerts(ids: ids)
    }
}

extension AlertsPresenter: AlertsInteractorOutput {
    func onDidLoadAlertsHistory(_ alerts: [Alert]) {
        view.update(alerts)
    }

    func updateAlertSuccessful(_ alert: Alert) {
        view.updateAlert(alert)
    }

    func deleteAlertsSuccessful(ids: [Int]) {
        view.deleteAlerts(withIds: ids)
    }

    func setSubscription(_ package: ISubscriptionPackage) {
        view.setSubscription(package)
    }
}
