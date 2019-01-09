//
//  VinsoAPI.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper


struct ConnectionObservation {
    weak var observer: VinsoAPIConnectionDelegate?
}

struct AlertsObservation {
    weak var observer: AlertsAPIResponseDelegate?
}

class VinsoAPI {
    static var shared = VinsoAPI()

    private var socketManager: SocketManager!
    private let ServerURL = ServerURLList.global.rawValue

    private var connectionObservers = [ObjectIdentifier : ConnectionObservation]()
    private var alertsObservers = [ObjectIdentifier : AlertsObservation]()

    private(set) var isLogined = false {
        didSet {
            connectionObservers.forEach({ $0.value.observer?.onDidLogin() })
        }
    }

    private init() {
        initSocket()
    }

    func initSocket() {
        socketManager = SocketManager(serverURL: ServerURL)
        socketManager.callbackOnOpen = {
            [weak self] in
            self?.connectionObservers.forEach({ $0.value.observer?.onConnectionOpened() })
            self?.login()
        }
        socketManager.callbackOnClose = {
            [weak self] _, _, _ in
            self?.isLogined = false
        }
        socketManager.callbackOnError = {
            [weak self] _ in
            self?.isLogined = false
        }
        socketManager.callbackOnMessage = { data in
            self.handleMessage(data)
        }
    }

    func isConnectionOpen() -> Bool {
        return socketManager.isOpen()
    }

    func handleMessage(_ data: Any) {
        guard let message = data as? String else {
            print("socket => can't cast data to String")
            return
        }
        print("socket => received message: \(message)")
        
        let json = JSON(parseJSON: message)
        guard let responseCode = json["status"].int,
              let responseCodeType = VinsoResponseCode(rawValue: responseCode) else {
            print("socket => fail cast code \(json["status"].int ?? -1) into ResponseCode")
            return
        }

        if responseCodeType != VinsoResponseCode.succeed {
            print("socket => responseCode != ResponseCode.Succeed")
            return
        }

        parseJSON(json: json)
    }

    func parseJSON(json: JSON) {
        guard let requestId = json["request_type"].int, let requestType = ServerMessage(rawValue: requestId) else {
            print("parseJSON => request_type out of range. request_type = \(json["request_type"].int ?? -999)")
            return
        }
        
        switch requestType {
        case ServerMessage.Authorization:
            isLogined = true
            connectionObservers.forEach({ $0.value.observer?.onDidLogin() })
            print("Vinso: login succeed")
        case ServerMessage.AlertsHistory: handleResponseAlertsLoaded(json: json)
        case ServerMessage.CreateAlert: handleResponseCreateAlert(json: json)
        case ServerMessage.UpdateAlert: handleResponseUpdateAlert(json: json)
        case ServerMessage.DeleteAlert: handleResponseDeleteAlert(json: json)
        case ServerMessage.FireAlert: handleResponseFireAlert(json: json)
        default:
            break
        }
    }

    private func getJSONMessage(messageType: ServerMessage) -> JSON {
        return [
            "request_type" : messageType.rawValue,
        ]
    }
    
    fileprivate func getDictionaryFromJSON(json: JSON) -> [String: Any]? {
        guard let alertServerMap = json["data"].dictionaryObject else {
            print("can't parse json data")
            return nil
        }
        return alertServerMap
    }
}

extension VinsoAPI {
    func establishConnect() {
        print("\(String(describing: self)) => establish connect")
        socketManager.connect(message: AccountApiRequestBuilder.buildConnectRequest())
    }

    func disconnect() {
        print("\(String(describing: self)) => disconnect")
        socketManager.disconnect()
    }

    func login() {
        print("\(String(describing: self)) => login")
        let msg = AccountApiRequestBuilder.buildAuthorizationRequest()
        socketManager.sendMessage(message: msg)
    }
}

// @MARK: manage alerts
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
}

// @MARK: handle alerts responses
extension VinsoAPI {
    private func handleResponseAlertsLoaded(json: JSON) {
        guard let jsonAlerts = json["history_alerts"].array else {
            print("handleResponseAlertsLoaded => can't parse json data")
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

    private func handleResponseCreateAlert(json: JSON) {
        if let _ = Alert(JSONString: json.description) {
            alertsObservers.forEach({ $0.value.observer?.onDidCreateAlertSuccessful() })
        }
    }
    
    private func handleResponseUpdateAlert(json: JSON) {
        guard let alert = Alert(JSONString: json.description)else {
            return
        }
        alertsObservers.forEach({ $0.value.observer?.onDidUpdateAlertSuccessful(alert) })
    }
    
    private func handleResponseFireAlert(json: JSON) {
        // do nothing
    }
    
    private func handleResponseDeleteAlert(json: JSON) {
        guard let alertDict = json.dictionary,
              let id = alertDict["deleted_alerts_id"]?.array?.first?.int else {
            return
        }
        alertsObservers.forEach({ $0.value.observer?.onDidDeleteAlertSuccessful(withId: id) })
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

extension VinsoAPI {
    func addConnectionObserver(_ observer: VinsoAPIConnectionDelegate) {
        let id = ObjectIdentifier(observer)
        connectionObservers[id] = ConnectionObservation(observer: observer)
    }

    func removeConnectionObserver(_ observer: VinsoAPIConnectionDelegate) {
        let id = ObjectIdentifier(observer)
        connectionObservers.removeValue(forKey: id)
    }
}
