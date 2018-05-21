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
    enum ConnectionConfig: String {
        case ServerURL = "ws://localhost:3000/"
    }
    
    private var socket: WebSocket!
    
    init() {
        self.socket = WebSocket(ConnectionConfig.ServerURL.rawValue)
        self.setSocketEvents()
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
    
    //
    // @MARK: common private methods
    //
    private func setSocketEvents() {
        self.socket.event.open = {
            print("socket connected")
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

        }
    }
    
    private func sendMessage(message: JSON) {
        if message.rawString() != nil {
            print("socket send message: " + message.rawString()!)
            socket.send(text: message.rawString()!)
        }
    }
    //
    // @MARK: Common JSON code
    //
    private func getJSONMessage(topic: AlertsAPIHelper.AlertMessageSettings, type: AlertsAPIHelper.AlertMessageType, data: JSON) -> JSON {
        return [
            "commandType" : 0,
            "uuid" : "Denys123",
            "topic": topic.rawValue,
            "type" : type.rawValue,
            "data" : data
        ]
    }
    
    //
    // @MARK: Alerts
    //
    func createAlert(alertItem: AlertItem) {
        let alertJSONData = AlertsAPIHelper.prepareJSONForCreateAlert(alertItem: alertItem)
        let msg = getJSONMessage(topic: .Topic, type: .Create, data: alertJSONData)
        
        sendMessage(message: msg)
    }
    
    func updateAlert(alertItem: AlertItem) {
        let alertJSONData = AlertsAPIHelper.prepareJSONForUpdateAlert(alertItem: alertItem)
        let msg = getJSONMessage(topic: .Topic, type: .Update, data: alertJSONData)
        
        sendMessage(message: msg)
    }
    
    func deleteAlert(alertItem: AlertItem) {
        let alertJSONData = AlertsAPIHelper.prepareJSONForDeleteAlert(alertItem: alertItem)
        let msg = getJSONMessage(topic: .Topic, type: .Update, data: alertJSONData)
        
        sendMessage(message: msg)
    }
}
