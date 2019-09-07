//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import SwiftyJSON
import RxSwift

struct AlertsObservation {
    weak var observer: AlertsAPIResponseDelegate?
}

// MARK: manage alerts
extension VinsoAPI {
    func loadAlerts() {
        log.info("fetching user alerts")
        socketManager.send(message: AlertsApiRequestBuilder.getJSONForAlertsHistory())
    }

    func deleteAlert(withId id: Int) {
        log.debug("delete alert \(id)")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlert(withId: id)
        socketManager.send(message: jsonMsg)
    }

    func deleteAlerts(withId ids: [Int]) {
        log.debug("delete alert \(ids)")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlerts(withIds: ids)
        socketManager.send(message: jsonMsg)
    }
    
    func selectedCurrencies() {
        log.info("fetching info for selected currencies")
        socketManager.send(message: AlertsApiRequestBuilder.getJSONForSelectedCurrencies())
    }
    
}

// MARK: handle alerts responses
extension VinsoAPI {
    // MARK: responses on load alerts history
    func handleResponseAlertsLoaded(json: JSON) {
        guard let jsonAlerts = json["history_alerts"].array else {
            log.error("handleResponseAlertsLoaded => can't parse json data")
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
        log.debug(json)
    }

    func handleResponseFireAlertError(reason: String) {
        log.debug(reason)
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
        _ = try? JSONDecoder().decode(CHSubscriptionPackage.self, from: json.rawData())
    }

    func handleResponseSubscriptionConfigsError(json: JSON) {

    }

    // MARK: responses on reset user
    func handleResponseResetUser(json: JSON) {
        connectionObservers.forEach({ $0.value.observer?.onResetUserSuccessful() })
    }

    func handleResponseResetUserError(reason: String) {
        log.debug(reason)
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

extension Reactive where Base: VinsoAPI {
    
    func getAlerts() -> Single<[Alert]> {
        return self.base.sendRequest(messageType: .alertsHistory)
            .mapInBackground{ json -> [Alert] in
                guard let jsonAlerts = json["history_alerts"].array else {
                    throw CHVinsoAPIError.missingRequiredParams
                }

                let alerts: [Alert] = jsonAlerts.compactMap{ Alert(JSONString: $0.description) }
                return alerts
            }
            .asSingle()
    }
    
    func createAlert(alert: Alert) -> Single<Alert?> {
        let jsonMsg = AlertsApiRequestBuilder.getJSONForCreateAlert(alert: alert)
        return self.base.sendRequest(messageType: .createAlert, params: jsonMsg.dictionaryObject!)
            .mapInBackground{ json in
                guard let alert = Alert(JSONString: json["alert"].description) else {
                    throw CHVinsoAPIError.missingRequiredParams
                }
                return alert
            }
            .asSingle()
    }
    
    func updateAlert(_ alert: Alert) -> Single<Void> {
        let jsonMsg = AlertsApiRequestBuilder.getJSONForUpdateAlert(alert: alert)
        return self.base.sendRequest(messageType: .updateAlert, params: jsonMsg.dictionaryObject!)
            .mapInBackground{ json in
                log.debug(json)
            }
            .asSingle()
    }
    
    func deleteAlert(_ alert: Alert) -> Single<Void> {
        return deleteAlerts([alert])
    }
    
    func deleteAlerts(_ alerts: [Alert]) -> Single<Void> {
        let alertsIds = alerts.compactMap{ $0.id }
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlerts(withIds: alertsIds)
        return self.base.sendRequest(messageType: .deleteAlert, params: jsonMsg.dictionaryObject!)
            .mapInBackground{ json in
                log.debug(json)
            }
            .asSingle()
    }
    
}
