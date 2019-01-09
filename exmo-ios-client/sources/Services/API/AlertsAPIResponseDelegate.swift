//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol AlertsAPIResponseDelegate: class {
    func onDidLoadAlertsHistorySuccessful(_ alerts: [Alert])
    func onDidCreateAlertSuccessful()
    func onDidUpdateAlertSuccessful(_ alert: Alert)
    func onDidDeleteAlertSuccessful(withId id: Int)
}

extension AlertsAPIResponseDelegate {
    func onDidLoadAlertsHistorySuccessful(_ alerts: [Alert]) { }
    func onDidCreateAlertSuccessful() { }
    func onDidUpdateAlertSuccessful(_ alert: Alert) { }
    func onDidDeleteAlertSuccessful(withId id: Int) { }
}