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

class VinsoAPI {
    static var shared = VinsoAPI()

    private(set) var socketManager: SocketManager!

    var connectionObservers = [ObjectIdentifier : ConnectionObservation]()
    var alertsObservers = [ObjectIdentifier : AlertsObservation]()

    private(set) var isLogined = false {
        didSet {
            if isLogined {
                connectionObservers.forEach({ $0.value.observer?.onDidLogin() })
            }
        }
    }

    private init() {
        initSocket()
    }

    func initSocket() {
        socketManager = SocketManager(serverURL: ServerURLList.local.rawValue)
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
            self.handleSocketMessage(data)
        }
    }

    func isConnectionOpen() -> Bool {
        return socketManager.isOpen()
    }
}

extension VinsoAPI {
    func handleSocketMessage(_ data: Any) {
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

        handleResponseMessage(json: json)
    }

    func handleResponseMessage(json: JSON) {
        guard let requestId = json["request_type"].int, let requestType = ServerMessage(rawValue: requestId) else {
            print("handleResponseMessage => request_type out of range. request_type = \(json["request_type"].int ?? -999)")
            return
        }

        switch requestType {
        case ServerMessage.Authorization:
            isLogined = true
            print("Vinso: Authorization succeed")
        case ServerMessage.AlertsHistory: handleResponseAlertsLoaded(json: json)
        case ServerMessage.CreateAlert: handleResponseCreateAlert(json: json)
        case ServerMessage.UpdateAlert: handleResponseUpdateAlert(json: json)
        case ServerMessage.DeleteAlert: handleResponseDeleteAlert(json: json)
        case ServerMessage.FireAlert: handleResponseFireAlert(json: json)
        default:
            break
        }
    }
}

extension VinsoAPI {
    func getJSONMessage(messageType: ServerMessage) -> JSON {
        return [
            "request_type" : messageType.rawValue,
        ]
    }

    func getDictionaryFromJSON(json: JSON) -> [String: Any]? {
        guard let alertServerMap = json["data"].dictionaryObject else {
            print("can't parse json data")
            return nil
        }
        return alertServerMap
    }
}