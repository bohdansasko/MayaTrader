//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import SwiftyJSON

struct AlertsObservation {
    weak var observer: AlertsAPIResponseDelegate?
}

// MARK: manage alerts
extension VinsoAPI {
    func loadAlerts() {
        print("load alerts")
        socketManager.sendMessage(message: AlertsApiRequestBuilder.getJSONForAlertsHistory())
    }

    func createAlert(alert: Alert) {
        print("create alert")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForCreateAlert(alert: alert)
        socketManager.sendMessage(message: jsonMsg)
    }

    func updateAlert(_ alert: Alert) {
        print("update alert")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForUpdateAlert(alert: alert)
        socketManager.sendMessage(message: jsonMsg)
    }

    func deleteAlert(withId id: Int) {
        print("delete alert \(id)")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlert(withId: id)
        socketManager.sendMessage(message: jsonMsg)
    }

    func deleteAlerts(withId ids: [Int]) {
        print("delete alert \(ids)")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlerts(withId: ids)
        socketManager.sendMessage(message: jsonMsg)
    }
    
    func selectedCurrencies() {
        print("load alerts")
        socketManager.sendMessage(message: AlertsApiRequestBuilder.getJSONForSelectedCurrencies())
    }
    
}

// MARK: handle alerts responses
extension VinsoAPI {
    // MARK: responses on load alerts history
    func handleResponseAlertsLoaded(json: JSON) {
        guard let jsonAlerts = json["history_alerts"].array else {
            print("handleResponseAlertsLoaded => can't parse json data")
            alertsObservers.forEach({ $0.value.observer?.onDidLoadAlertsHistorySuccessful([]) })
            return
        }

        var alerts: [Alert] = []
        for jsonAlert in jsonAlerts {
            if let alert = Alert(JSONString: jsonAlert.description) {
                alerts.append(alert)
            }
        }
        alerts.sort(by: { $0.dateCreated > $1.dateCreated })
        alertsObservers.forEach({ $0.value.observer?.onDidLoadAlertsHistorySuccessful(alerts) })
    }

    func handleResponseAlertsLoadedError(reason: String) {
        alertsObservers.forEach({ $0.value.observer?.onDidLoadAlertsHistoryError(msg: reason) })
    }

    // MARK: responses on create alert
    func handleResponseCreateAlert(json: JSON) {
        if let _ = Alert(JSONString: json.description) {
            alertsObservers.forEach({ $0.value.observer?.onDidCreateAlertSuccessful() })
        }
    }

    func handleResponseErrorCreateAlert(reason: String) {
        alertsObservers.forEach({ $0.value.observer?.onDidCreateAlertError(msg: reason) })
    }

    // MARK: responses on update alert
    func handleResponseUpdateAlert(json: JSON) {
        guard let alert = Alert(JSONString: json.description)else {
            return
        }
        alertsObservers.forEach({ $0.value.observer?.onDidUpdateAlertSuccessful(alert) })
    }

    func handleResponseErrorUpdateAlert(reason: String) {
        alertsObservers.forEach({ $0.value.observer?.onDidUpdateAlertError(msg: reason) })
    }

    // MARK: responses on fire alert
    func handleResponseFireAlert(json: JSON) {
        print(json)
    }

    func handleResponseFireAlertError(reason: String) {
        print(reason)
    }

    // MARK: responses on delete alert
    func handleResponseDeleteAlert(json: JSON) {
        guard let alertDict = json.dictionary,
              let ids = alertDict["deleted_alerts_id"]?.array?.map({ $0.intValue }) else {
            return
        }
        alertsObservers.forEach({ $0.value.observer?.onDidDeleteAlertsSuccessful(ids: ids) })
    }

    func handleResponseErrorDeleteAlert(reason: String) {
        alertsObservers.forEach({ $0.value.observer?.onDidDeleteAlertsError(msg: reason) })
    }

    // MARK: responses on subscriptions loaded
    func handleResponseSubscriptionConfigs(json: JSON) {
        _ = try? JSONDecoder().decode(SubscriptionPackage.self, from: json.rawData())
    }

    func handleResponseSubscriptionConfigsError(json: JSON) {

    }

    // MARK: responses on reset user
    func handleResponseResetUser(json: JSON) {
        connectionObservers.forEach({ $0.value.observer?.onResetUserSuccessful() })
    }

    func handleResponseResetUserError(reason: String) {
        print(reason)
    }
}

extension VinsoAPI {
    func addAlertsObserver(_ observer: AlertsAPIResponseDelegate) {
        let id = ObjectIdentifier(observer)
        alertsObservers[id] = AlertsObservation(observer: observer)
    }

    func removeAlertsObserver(_ observer: AlertsAPIResponseDelegate) {
        let id = ObjectIdentifier(observer)
        alertsObservers.removeValue(forKey: id)
    }
}
