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
        print("load alerts")
        socketManager.send(message: AlertsApiRequestBuilder.getJSONForAlertsHistory())
    }

    func deleteAlert(withId id: Int) {
        print("delete alert \(id)")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlert(withId: id)
        socketManager.send(message: jsonMsg)
    }

    func deleteAlerts(withId ids: [Int]) {
        print("delete alert \(ids)")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlerts(withIds: ids)
        socketManager.send(message: jsonMsg)
    }
    
    func selectedCurrencies() {
        print("load alerts")
        socketManager.send(message: AlertsApiRequestBuilder.getJSONForSelectedCurrencies())
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
        _ = try? JSONDecoder().decode(CHSubscriptionPackage.self, from: json.rawData())
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

extension Reactive where Base: VinsoAPI {
    
    func getAlerts() -> Single<[Alert]> {
        return self.base.sendRequest(messageType: .alertsHistory)
            .mapInBackground{ json -> [Alert] in
                guard let jsonAlerts = json["history_alerts"].array else {
                    return []
                }
                let jsonStr = """
{
  "alert_status" : 0,
  "currency" : "STQ_EUR",
  "timestamp" : 1565640964,
  "is_persistent" : false,
  "bottom_bound" : "0.0001",
  "status" : 200,
  "upper_bound" : "0.0001",
  "price_at_create_moment" : "0.0001",
  "alert_id" : 0,
  "request_type" : 4,
  "description" : ""
}
"""
                let alerts: [Alert] = [
                    Alert(JSONString: jsonStr)!,
                    Alert(JSONString: jsonStr)!,
                    Alert(JSONString: jsonStr)!
                ]
                return alerts

//                let alerts: [Alert] = jsonAlerts.compactMap{ Alert(JSONString: $0.description) }
//                return alerts
            }
            .asSingle()
    }
    
    func createAlert(alert: Alert) -> Single<Alert?> {
        print("create alert")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForCreateAlert(alert: alert)
        return self.base.sendRequest(messageType: .createAlert, params: jsonMsg.dictionaryObject!)
            .mapInBackground{ json in
                guard let alert = Alert(JSONString: json.description) else {
                    return nil
                }
                return alert
            }
            .asSingle()
    }
    
    func updateAlert(_ alert: Alert) -> Single<Void> {
        print("update alert")
        let jsonMsg = AlertsApiRequestBuilder.getJSONForUpdateAlert(alert: alert)
        return self.base.sendRequest(messageType: .updateAlert, params: jsonMsg.dictionaryObject!)
            .mapInBackground{ json in
                print(json)
            }
            .asSingle()
    }
    
    func deleteAlert(_ alert: Alert) -> Single<Void> {
        return deleteAlerts([alert])
    }
    
    func deleteAlerts(_ alerts: [Alert]) -> Single<Void> {
        print("\(#function)")
        let alertsIds = alerts.compactMap{ $0.id }
        let jsonMsg = AlertsApiRequestBuilder.getJSONForDeleteAlerts(withIds: alertsIds)
        return self.base.sendRequest(messageType: .deleteAlert, params: jsonMsg.dictionaryObject!)
            .mapInBackground{ json in
                print(json)
            }
            .asSingle()
    }
    
}
