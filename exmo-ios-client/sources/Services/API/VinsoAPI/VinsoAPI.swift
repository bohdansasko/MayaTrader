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
    enum ConnectionNotification: String, NotificationName {
        case connectedSuccess
        case connectionError
        
        case authorizationSuccess
        case authorizationError
    }
    
    enum AlertsNotification: String, NotificationName {
        case loadedHistorySuccess
        case createdAlertSuccess
        case updatedAlertSuccess
        case deletedAlertSuccess
        
        case loadedHistoryError
        case createdAlertError
        case updatedAlertError
        case deletedAlertError
    }

    static var shared = VinsoAPI()

    private(set) var socketManager: SocketManager!

    var connectionObservers = [ObjectIdentifier : ConnectionObservation]()
    var alertsObservers = [ObjectIdentifier : AlertsObservation]()

    var isAuthorized = false {
        didSet {
            if isAuthorized {
                AppDelegate.vinsoAPI.setSubscriptionType(IAPService.shared.subscriptionPackage.type)
                connectionObservers.forEach({ $0.value.observer?.onDidLogin() })
            }
        }
    }

    private init() {
        initSocket()
        subscribeOnIAPEvents()
    }

    deinit {
        unsubscribeEvents()
    }

    func initSocket() {
        let endpointUrl = APIURLs.global.rawValue
        print("Init socket with url \(endpointUrl)")
        socketManager = SocketManager(serverURL: endpointUrl)
        socketManager.callbackOnOpen = {
            [weak self] in
            self?.login()
        }
        socketManager.callbackOnClose = {
            [weak self] _, reason, _ in
            self?.onSocketClose(reason: reason)
        }
        socketManager.callbackOnError = {
            [weak self] error in
            self?.onSocketError(reason: error.localizedDescription)
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

        switch responseCodeType {
        case .succeed: handleSuccessResponseMessage(json: json)
        case .error, .clientError: handleErrorResponseMessage(json: json)
        }
    }

    func handleSuccessResponseMessage(json: JSON) {
        guard let requestId = json["request_type"].int, let requestType = ServerMessage(rawValue: requestId) else {
            print("handleResponseMessage => request_type out of range. request_type = \(json["request_type"].int ?? -999)")
            return
        }

        switch requestType {
        case ServerMessage.authorization:
            isAuthorized = true
            print("Vinso: Authorization succeed")
        case ServerMessage.alertsHistory: handleResponseAlertsLoaded(json: json)
        case ServerMessage.createAlert: handleResponseCreateAlert(json: json)
        case ServerMessage.updateAlert: handleResponseUpdateAlert(json: json)
        case ServerMessage.deleteAlert: handleResponseDeleteAlert(json: json)
        case ServerMessage.fireAlert: handleResponseFireAlert(json: json)
        case ServerMessage.subscriptionConfigs: handleResponseSubscriptionConfigs(json: json)
        default:
            break
        }
    }

    func handleErrorResponseMessage(json: JSON) {
        guard let requestId = json["request_type"].int,
              let requestType = ServerMessage(rawValue: requestId),
              let reason = json["reason"].string else {
            print("handleResponseMessage => request_type out of range. request_type = \(json["request_type"].int ?? -999)")
            return
        }

        print("\(#function) => \(json)")
        switch requestType {
        case ServerMessage.authorization: break
        case ServerMessage.alertsHistory: handleResponseAlertsLoadedError(reason: reason)
        case ServerMessage.createAlert: handleResponseErrorCreateAlert(reason: reason)
        case ServerMessage.updateAlert: handleResponseErrorUpdateAlert(reason: reason)
        case ServerMessage.deleteAlert: handleResponseErrorDeleteAlert(reason: reason)
        case ServerMessage.fireAlert: handleResponseFireAlertError(reason: reason)
        default: break
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


extension VinsoAPI {
    func subscribeOnIAPEvents() {
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPService.Notification.updateSubscription.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onPurchaseError(_ :)),
                name: IAPService.Notification.purchaseError.name)
    }

    func unsubscribeEvents() {
        AppDelegate.notificationController.removeObserver(self)
    }
}


extension VinsoAPI {
    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let subscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? ISubscriptionPackage else {
            print("\(#function) => can't convert notification container to IAPProduct")
            if AppDelegate.vinsoAPI.isAuthorized {
                AppDelegate.vinsoAPI.setSubscriptionType(.freeWithAds)
            }
            return
        }

        if AppDelegate.vinsoAPI.isAuthorized {
            AppDelegate.vinsoAPI.setSubscriptionType(subscriptionPackage.type)
        }
    }

    @objc
    func onPurchaseError(_ notification: Notification) {
        if AppDelegate.vinsoAPI.isAuthorized {
            AppDelegate.vinsoAPI.setSubscriptionType(.freeWithAds)
        }
    }
}