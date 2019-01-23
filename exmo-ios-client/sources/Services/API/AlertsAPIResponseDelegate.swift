//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol AlertsAPIResponseDelegate: class {
    func onDidLoadAlertsHistorySuccessful(_ alerts: [Alert])
    func onDidLoadAlertsHistoryError(msg: String)

    func onDidCreateAlertSuccessful()
    func onDidCreateAlertError(msg: String)

    func onDidUpdateAlertSuccessful(_ alert: Alert)
    func onDidUpdateAlertError(msg: String)

    func onDidDeleteAlertsSuccessful(ids: [Int])
    func onDidDeleteAlertsError(msg: String)
}

extension AlertsAPIResponseDelegate {
    func onDidLoadAlertsHistorySuccessful(_ alerts: [Alert]) { }
    func onDidLoadAlertsHistoryError(msg: String) { }

    func onDidCreateAlertSuccessful() { }
    func onDidCreateAlertError(msg: String) { }

    func onDidUpdateAlertSuccessful(_ alert: Alert) { }
    func onDidUpdateAlertError(msg: String) { }

    func onDidDeleteAlertsSuccessful(ids: [Int]) { }
    func onDidDeleteAlertsError(msg: String) { }
}