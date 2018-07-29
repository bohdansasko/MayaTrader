//
//  SocketAPIHandler.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 5/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftWebSocket
import SwiftyJSON

class SocketApiHandler {
    //
    // @MARK: enums
    //
    private enum ResponseCode {
        static let Succeed = 200
        static let Error = 0
    }
    
    private enum MessageType: Int {
        case Topic = 0
        case AccountTopic = 4
    }
    
    private enum AlertsActionMessageType: Int {
        case Create = 0
        case Update = 1
        case Delete = 2
        case History = 3
    }
    
    private enum ConnectionConfig: String {
        case ServerURL = "ws://localhost:3000/"
    }
    
    enum ServerMessages: Int {
        case LoginSucceed = 4
        case AlertHistory = 3
        case AlertDelete = 2
        case AlertUpdate = 1
        case CreateAlert = 0
    }
    
    //
    // @MARK: variables
    //
    private var socket: WebSocket!
    private var sessionKey: String?
    
    //
    // @MARK: common methods
    //
    init() {
        self.socket = WebSocket(ConnectionConfig.ServerURL.rawValue)
        self.setSocketEvents()
    }
    
    deinit {
        self.disconnect()
    }
    
    //
    // @MARK: common public methods
    //
    func connect() {
        self.socket.open()
        
        let message: JSON = [
            "commandType" : 1,
            "uuid" : "Denys123",
            "api_key" : "111",
            "api_secret" : "111"
        ]
        sendMessage(message: message)
    }
    
    func disconnect() {
        self.socket.close()
    }
    
    func loadAllRequiredSessionInfo() {
        self.loadAlerts()
    }
    
    //
    // @MARK: common private methods
    //
    private func setSocketEvents() {
        self.socket.event.open = {
            print("socket connected")
            self.signIn()
        }
        
        self.socket.event.close = { code, reason, clean in
            print("socket close")
            // send broadcast message
        }
        
        self.socket.event.error = { error in
            print("socket error: \(error)")
            // send broadcast message
            // handle broadcast message
        }
        
        self.socket.event.message = { serverMessage in
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
    }
    
    private func parseJSON(json: JSON) {
        if json["topic"] != JSON.null && json["topic"].int == ServerMessages.LoginSucceed.rawValue {
            self.sessionKey = json["session_key"].string
            self.loadAllRequiredSessionInfo()
            
            print("socket message[connection_id]: \(self.sessionKey!)")
            print("login succeed")
        } else if json["type"] != JSON.null {
            let messageCode = json["type"].int
            
            switch messageCode {
            case ServerMessages.AlertHistory.rawValue:
                self.handleResponseUpdateAlerts(json: json)
            case ServerMessages.CreateAlert.rawValue:
                self.handleResponseAppendAlert(json: json)
            case ServerMessages.AlertUpdate.rawValue:
                self.handleResponseUpdateAlert(json: json)
            case ServerMessages.AlertDelete.rawValue:
                self.handleResponseDeleteAlert(json: json)
                break
            default:
                break
            }
            
        }
    }
    
    private func handleResponseUpdateAlerts(json: JSON) {
        guard let jsonAlertsContainer = json["data"]["data"].array else {
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

        Session.sharedInstance.updateAlerts(alerts: alerts)
    }

    private func getAlertFromJSON(json: JSON) -> AlertItem? {
        guard var alertServerMap = json["data"]["data"].dictionaryObject else {
            print("can't parse json data")
            return nil
        }

        return AlertItem(JSON: alertServerMap)

    }
    
    private func handleResponseAppendAlert(json: JSON) {
        guard var alertServerMap = json["data"]["data"].dictionaryObject else {
            print("can't parse json data")
            return
        }
        
        alertServerMap["status"] = 1
        let alert = AlertItem(JSON: alertServerMap)
        if let alertObj = alert {
            Session.sharedInstance.appendAlert(alertItem: alertObj)
        }
    }
    
    private func handleResponseUpdateAlert(json: JSON) {
        let alert = getAlertFromJSON(json: json)
        if let alertObj = alert {
            Session.sharedInstance.updateAlert(alertItem: alertObj)
        }
    }

    private func handleResponseDeleteAlert(json: JSON) {
        guard var alertServerMap = json["data"]["data"].dictionaryObject else {
            print("can't parse json data")
            return
        }
        let alertIdFromJson = alertServerMap["server_alert_id"] as? String
        if let alertId = alertIdFromJson {
            Session.sharedInstance.deleteAlert(alertId: alertId)
        }
    }

    private func sendMessage(message: JSON) {
        guard let msg = message.rawString() else {
            return
        }
        
        if !msg.isEmpty {
            print("socket send message: " + msg)
            socket.send(text: msg)
        }
    }
    //
    // @MARK: Common JSON code
    //
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
    
    //
    // @MARK: login
    //
    func signIn() {
        let jsonMsg = AccountApiRequestBuilder.buildLoginRequest(login: "denys", password: "denys", exchangeDomain: .Roobik)
        let msg = getJSONMessage(type: .AccountTopic,
                                 actionTypeRawValue: AccountApiRequestBuilder.ProcedureType.SignIn.rawValue,
                                 data: jsonMsg)
        sendMessage(message: msg)
    }

    func signUp() {
        let jsonMsg = AccountApiRequestBuilder.buildSignUpRequest(email: "test@mail.com", firstName: "den1", lastName: "ys", login: "bodka", password: "bodka", exchangeDomain: .Roobik)
        let msg = getJSONMessage(type: .Topic,
                                 actionTypeRawValue: AccountApiRequestBuilder.ProcedureType.SignIn.rawValue,
                                 data: jsonMsg)
        sendMessage(message: msg)
    }
    
    //
    // @MARK: Alerts
    //
    func createAlert(alertItem: AlertItem) {
        let alertJSONData = AlertsApiRequestBuilder.prepareJSONForCreateAlert(alertItem: alertItem)
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsActionMessageType.Create.rawValue, data: alertJSONData)
        
        sendMessage(message: msg)
    }
    
    func updateAlert(alertItem: AlertItem) {
        let alertJSONData = AlertsApiRequestBuilder.prepareJSONForUpdateAlert(alertItem: alertItem)
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsActionMessageType.Update.rawValue, data: alertJSONData)
        
        sendMessage(message: msg)
    }
    
    func deleteAlert(alertId: String) {
        let alertJSONData = AlertsApiRequestBuilder.prepareJSONForDeleteAlert(alertId: alertId)
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsActionMessageType.Delete.rawValue, data: alertJSONData)
        
        sendMessage(message: msg)
    }
    
    private func loadAlerts() {
        print("load alerts")
        let msg = getJSONMessage(type: .Topic, actionTypeRawValue: AlertsActionMessageType.History.rawValue)
        sendMessage(message: msg)
    }
}
