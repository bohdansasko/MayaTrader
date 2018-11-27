//
//  RoobikApiHandler.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON

class RoobikApiHandler {
    static var shared = RoobikApiHandler()

    //
    // @MARK: variables
    //
    private var socketAPI: SocketApiHandler!
    private var sessionKey: String?

    //
    // @MARK: common methods
    //
    init() {
        self.socketAPI = SocketApiHandler(serverURL: ConnectionConfig.ServerURL.rawValue)
        self.socketAPI.callbackOnOpen = {
            print("socket is open")
        }
        self.socketAPI.callbackOnMessage = { serverMessage in
            guard let message = serverMessage as? String else {
                print("socket message: got wrong message")
                return
            }
            print("socket message: \(message)")

            let json = JSON(parseJSON: message)

            let responseCode = json["response_code"].int
            if responseCode == ResponseCode.Error {
                print("responseCode == ResponseCode.Error")
                return
            }
            self.parseJSON(json: json)
        }
        self.socketAPI.callbackOnClose = { code, reason, clean in
            print("socket is closed. details: code = \(code), reason = \(reason), wasClean\(clean)")
        }
        
        self.socketAPI.callbackOnError = { error in
            print("socket error: \(error)")
        }

        let message: JSON = [
            "commandType" : 1,
            "uuid" : "Denys123",
            "api_key" : "111",
            "api_secret" : "111"
        ]
        self.socketAPI.connect(message: message)
    }

    func loadAllRequiredSessionInfo() {
        self.loadAlerts()
    }

    fileprivate func parseJSON(json: JSON) {
        let messageTopic = json["topic"].int
        var messageType = AlertsMessageType.None.rawValue

        if json["type"] != JSON.null {
            messageType = json["type"].int!
        }

        switch messageTopic {
        case ServerMessageType.Authorization.rawValue:
            self.sessionKey = json["session_key"].string
            self.loadAllRequiredSessionInfo()

            print("socket message[connection_id]: \(self.sessionKey!)")
            print("login succeed")
            break
        case ServerMessageType.Alerts.rawValue:
            switch messageType {
            case AlertsMessageType.History.rawValue:
                self.handleResponseUpdateAlerts(json: json)
                break
            case AlertsMessageType.Create.rawValue:
                self.handleResponseAppendAlert(json: json)
                break
            case AlertsMessageType.Update.rawValue:
                self.handleResponseUpdateAlert(json: json)
                break
            case AlertsMessageType.Delete.rawValue:
                self.handleResponseDeleteAlert(json: json)
                break
            default:
                break
            }
            break
        case ServerMessageType.Orders.rawValue:
            switch messageType {
            case OrdersMessageType.Create.rawValue:
                self.handleResponseCreateOrders(json: json)
                break
            case OrdersMessageType.Cancel.rawValue:
                self.handleResponseCancelOrders(json: json)
                break
            case OrdersMessageType.Deals.rawValue:
                self.handleResponseDealsOrders(json: json)
                // do nothing
                break
            default:
                break
            }
            break
        default:
            break
        }
    }

    private func getJSONMessage(type: MessageType, actionTypeRawValue: Int, data: JSON = JSON()) -> JSON {
        var json: JSON = [
            "request_id" : "test_request",
            "uuid" : "Denys123",
            "topic": type.rawValue,
            "type" : actionTypeRawValue,
            "data" : data
        ]

        if self.sessionKey != nil {
            json["session_key"] = JSON(self.sessionKey!)
        }

        return json
    }
    
    fileprivate func getDictionaryFromJSON(json: JSON) -> [String: Any]? {
        guard let alertServerMap = json["data"].dictionaryObject else {
            print("can't parse json data")
            return nil
        }
        return alertServerMap
    }
    
    fileprivate func getArrayFromJSON(json: JSON) -> [JSON]? {
        guard let array = json["data"].array else {
            print("can't parse json data")
            return nil
        }
        return array
    }
}

//
// @MARK: enums
//
extension RoobikApiHandler {
    fileprivate enum ResponseCode {
        static let Succeed = 200
        static let Error = 0
    }

    fileprivate enum MessageType: Int {
        case Topic = 0
        case AccountTopic = 4
    }

    fileprivate enum AlertsMessageType: Int {
        case None = -1
        case Create = 0
        case Update = 1
        case Delete = 2
        case History = 3
    }

    fileprivate enum OrdersMessageType: Int {
        case Create = 0
        case Cancel = 1
        case Deals = 2
    }

    fileprivate enum ConnectionConfig: String {
        case ServerURL = "ws://193.228.52.26:3000/"
    }

    fileprivate enum ServerMessageType: Int {
        case Alerts = 0
        case Orders = 1
        case Authorization = 4
    }
}

//
// @MARK: login
//
extension RoobikApiHandler {
    func signIn() {
        let jsonMsg = AccountApiRequestBuilder.buildLoginRequest(login: "denys", password: "denys", exchangeDomain: .Roobik)
        let msg = getJSONMessage(type: .AccountTopic,
                actionTypeRawValue: AccountApiRequestBuilder.ProcedureType.SignIn.rawValue,
                data: jsonMsg)
        self.socketAPI.sendMessage(message: msg)
    }

    func signUp() {
        let jsonMsg = AccountApiRequestBuilder.buildSignUpRequest(email: "test@mail.com", firstName: "den1", lastName: "ys", login: "bodka", password: "bodka", exchangeDomain: .Roobik)
        let msg = getJSONMessage(type: .Topic,
                actionTypeRawValue: AccountApiRequestBuilder.ProcedureType.SignIn.rawValue,
                data: jsonMsg)
        self.socketAPI.sendMessage(message: msg)
    }
}

//
// @MARK: orders
//
extension RoobikApiHandler {
    //
    // @MARK: orders requests
    //
    fileprivate func loadOrders() {
        print("load alerts")
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: OrdersMessageType.Deals.rawValue)
        self.socketAPI.sendMessage(message: msg)
    }
    
    func createOrder(order: OrderModel) {
        // do nothing
    }
    
    func cancelOrder(order: OrderModel) {
        // do nothing
    }

    //
    // @MARK: handle alert response
    //
    private func handleResponseCreateOrders(json: JSON) {
        // do nothing
    }
    
    private func handleResponseCancelOrders(json: JSON) {
        // do nothing
    }
    
    private func handleResponseDealsOrders(json: JSON) {
        // do nothing
    }
}

//
// @MARK: alerts
//
extension RoobikApiHandler {
    private func getAlertFromJSON(json: JSON) -> AlertItem? {
        guard let alertServerMap = getDictionaryFromJSON(json: json) else {
            return nil
        }
        return AlertItem(JSON: alertServerMap)
    }

    //
    // @MARK: alerts requests
    //
    private func loadAlerts() {
        print("load alerts")
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsMessageType.History.rawValue)
        self.socketAPI.sendMessage(message: msg)
    }
    
    func createAlert(alertItem: AlertItem) {
        let alertJSONData = AlertsApiRequestBuilder.prepareJSONForCreateAlert(alertItem: alertItem)
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsMessageType.Create.rawValue, data: alertJSONData)

        self.socketAPI.sendMessage(message: msg)
    }

    func updateAlert(alertItem: AlertItem) {
        let alertJSONData = AlertsApiRequestBuilder.prepareJSONForUpdateAlert(alertItem: alertItem)
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsMessageType.Update.rawValue, data: alertJSONData)

        self.socketAPI.sendMessage(message: msg)
    }

    func deleteAlert(alertId: String) {
        let alertJSONData = AlertsApiRequestBuilder.prepareJSONForDeleteAlert(alertId: alertId)
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsMessageType.Delete.rawValue, data: alertJSONData)

        self.socketAPI.sendMessage(message: msg)
    }

    //
    // @MARK: handle alert response
    //
    private func handleResponseAppendAlert(json: JSON) {
        guard var alertServerMap = self.getDictionaryFromJSON(json: json) else {
            return
        }

        alertServerMap["status"] = 1
        let alert = AlertItem(JSON: alertServerMap)
        if let alertObj = alert {
            AppDelegate.session.appendAlert(alertItem: alertObj)
        }
    }

    private func handleResponseUpdateAlert(json: JSON) {
        let alert = getAlertFromJSON(json: json)
        if let alertObj = alert {
            AppDelegate.session.updateAlert(alertItem: alertObj)
        }
    }

    private func handleResponseUpdateAlerts(json: JSON) {
        guard let jsonAlertsContainer = getArrayFromJSON(json: json) else {
            print("can't parse json data")
            return
        }

        var alerts: [AlertItem] = []
        for jsonAlertItem in jsonAlertsContainer {
            let alert = AlertItem(JSONString: jsonAlertItem.rawString()!)
            if let alertObj = alert {
                alerts.append(alertObj)
                print(alertObj.getDataAsText())
            }
        }

        AppDelegate.session.appendAlerts(alerts: alerts)
    }

    private func handleResponseDeleteAlert(json: JSON) {
        guard var alertServerMap = self.getDictionaryFromJSON(json: json) else {
            return
        }
        let alertIdFromJson = alertServerMap["server_alert_id"] as? String
        if let alertId = alertIdFromJson {
            AppDelegate.session.deleteAlert(alertId: alertId)
        }
    }
}
