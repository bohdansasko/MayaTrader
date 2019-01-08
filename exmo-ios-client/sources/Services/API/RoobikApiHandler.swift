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

fileprivate enum ResponseCode {
    static let Succeed = 200
    static let Error = 0
}

enum ServerMessage: Int {
    case Bad = -1
    case Connect = 0
    case Registration = 1
    case Authorization = 2
    case ConfirmRegistration = 3
    case CreateAlert = 4
    case UpdateAlert = 5
    case DeleteAlert = 6
    case FireAlert = 7
    case ResetUser = 9
    case AlertsHistory = 10
}

protocol VinsoAPIConnectionDelegate: class {
    func onConnectionOpened()
    func onLogined()
}

protocol AlertsAPIResponseDelegate: class {
    func onDidLoadAlertsHistorySuccessful(_ alerts: [Alert])
    func onDidUpdateAlertSuccessful(_ alert: Alert)
    func onDidDeleteAlertSuccessful(withId id: Int)
}

class VinsoAPI {
    static var shared = VinsoAPI()

    private var socketManager: SocketManager!
    private let ServerURL = "ws://192.168.0.102:45667"

    weak var connectionDelegate: VinsoAPIConnectionDelegate?
    weak var alertsDelegate: AlertsAPIResponseDelegate?

    private init() {
        initSocket()
        connect()
    }

    func initSocket() {
        socketManager = SocketManager(serverURL: ServerURL)
        socketManager.callbackOnOpen = {
            self.connectionDelegate?.onConnectionOpened()
        }
        socketManager.callbackOnMessage = { data in
            self.handleMessage(data)
        }
    }

    func isConnectionOpen() -> Bool {
        return socketManager.isOpen()
    }
    
    func connect() {
        socketManager.connect(message: getJSONMessage(messageType: .Connect))
    }
    
    func handleMessage(_ data: Any) {
        guard let message = data as? String else {
            print("socket => can't cast data to String")
            return
        }
        print("socket => received message: \(message)")
        
        let json = JSON(parseJSON: message)
        let responseCode = json["status"].int
        if responseCode != ResponseCode.Succeed {
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
            connectionDelegate?.onLogined()
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

// @MARK: login
extension VinsoAPI {
    func login() {
        let msg = AccountApiRequestBuilder.buildLoginRequest()
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
        alertsDelegate?.onDidLoadAlertsHistorySuccessful(alerts)
    }

    private func handleResponseCreateAlert(json: JSON) {
//        guard var alertServerMap = self.getDictionaryFromJSON(json: json) else {
//            return
//        }
//
//        alertServerMap["status"] = 1
//        let alert = Alert(JSON: alertServerMap)
//        if let alertObj = alert {
//            AppDelegate.session.appendAlert(alert: alertObj)
//        }
    }
    
    private func handleResponseUpdateAlert(json: JSON) {
        guard let alert = Alert(JSONString: json.description)else {
            return
        }
        alertsDelegate?.onDidUpdateAlertSuccessful(alert)
    }
    
    private func handleResponseFireAlert(json: JSON) {
        // do nothing
    }
    
    private func handleResponseDeleteAlert(json: JSON) {
        guard let alertDict = json.dictionary,
              let id = alertDict["deleted_alerts_id"]?.array?.first?.int else {
            return
        }
        alertsDelegate?.onDidDeleteAlertSuccessful(withId: id)
    }
}
