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
import RxSwift

enum CHVinsoAPIError: String, Error {
    case unknown = "Unknown error"
}

enum CHStockExchange: String {
    case exmo     = "exmo"
    case btcTrade = "btc_trade"
}

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

class VinsoAPI {

    static var shared = VinsoAPI()

    private(set) var socketManager: SocketManager!
    fileprivate let disposeBag = DisposeBag()
    
    var connectionObservers = [ObjectIdentifier : ConnectionObservation]()
    var alertsObservers = [ObjectIdentifier : AlertsObservation]()

    var isAuthorized = false {
        didSet {
            if isAuthorized {
                AppDelegate.vinsoAPI.setSubscriptionType(IAPService.shared.subscriptionPackage.type)
                connectionObservers.forEach({ $0.value.observer?.onAuthorization() })
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
        guard let config = try? PListFile<ConfigInfoPList>() else {
            return
        }

        let endpointUrl = config.model.configuration.endpoint
        print("Init socket with url \(endpointUrl)")
        
        socketManager = SocketManager(serverURL: endpointUrl)
        socketManager.callbackOnOpen = {
            [] in
            print("\(#function) => socket has opened")
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
    
    func connectToServer() {
//        self.socket.rx.connected.subscribe(onNext: { isConnected in
//            if !isConnected { return }
//            self.sendRequest(messageType: .connect)
//                .subscribe(onNext: { json in
//                    print("\(#function) = \(json)")
//                    self.tryToAuthorizateUser()
//                }, onError: { err in
//                    print("\(#function) = \(err.localizedDescription)")
//                }).disposed(by: self.disposeBag)
//
//        }).disposed(by: self.disposeBag)
//        self.socket.connect()
    }
    
    func tryToAuthorizateUser() {
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        let params = ["udid": udid]
        self.sendRequest(messageType: .authorization, params: params)
            .asSingle()
            .subscribe(onSuccess: { json in
                print("\(#function) = \(json)")
            }, onError: { err in
                print("\(#function) = \(err.localizedDescription)")
            }).disposed(by: self.disposeBag)
    }
    
    func sendRequest(messageType: ServerMessage, params: [String: Any?] = [:]) -> Observable<JSON> {
//        let request = Observable<JSON>.create{ [unowned self] subscriber in
//            self.socket.rx.response.subscribe(onNext: { event in
//                if case .message(let message) = event {
//                    let json = JSON(parseJSON: message)
//
//                    guard let responseCode = json["status"].int,
//                        let responseCodeType = VinsoResponseCode(rawValue: responseCode),
//                        let requestId = json["request_type"].int,
//                        let messageId = ServerMessage(rawValue: requestId) else {
//                            subscriber.onError(CHVinsoAPIError.unknown)
//                            return
//                    }
//
//                    print("😎 API Response: \(json)")
//
//                    switch responseCodeType {
//                    case .succeed where messageId == messageType:
//                        subscriber.onNext(json)
//                    case .succeed:
//                        break
//                    case .error, .clientError:
//                        subscriber.onError(CHVinsoAPIError.unknown)
//                    }
//                }
//            })
//        }
//
//        var data = params
//        data["request_type"] = messageType.rawValue
//        let message = JSON(data)
//
//        print("👻 API Request: \(message)")
//        assert(!message.isEmpty, "don't send empty messages")
//
//        self.socket.write(string: message.stringValue)
//
//        return request
        return Observable<JSON>.just("")
    }
    
}

extension VinsoAPI {
    func handleSocketMessage(_ data: Any) {
        guard let message = data as? String else {
            print("socket => can't cast data to String")
            return
        }
        print("🙂socket => received message: \(message)")

        let json = JSON(parseJSON: message)
        guard let responseCode = json["status"].int,
              let responseCodeType = VinsoResponseCode(rawValue: responseCode) else {
            print("🤮socket => fail cast code \(json["status"].int ?? -1) into ResponseCode")
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
        case ServerMessage.connect:
            login()
            print("Vinso: Connect succeed")
        case ServerMessage.authorization:
            isAuthorized = true
            print("Vinso: Authorization succeed")
        case ServerMessage.alertsHistory: handleResponseAlertsLoaded(json: json)
        case ServerMessage.createAlert: handleResponseCreateAlert(json: json)
        case ServerMessage.updateAlert: handleResponseUpdateAlert(json: json)
        case ServerMessage.deleteAlert: handleResponseDeleteAlert(json: json)
        case ServerMessage.resetUser: handleResponseResetUser(json: json)
        case ServerMessage.fireAlert: handleResponseFireAlert(json: json)
        case ServerMessage.getSelectedCurrencies: print(json)
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
        case ServerMessage.createAlert  : handleResponseErrorCreateAlert(reason: reason)
        case ServerMessage.updateAlert  : handleResponseErrorUpdateAlert(reason: reason)
        case ServerMessage.deleteAlert  : handleResponseErrorDeleteAlert(reason: reason)
        case ServerMessage.resetUser    : handleResponseResetUserError(reason: reason)
        case ServerMessage.fireAlert    : handleResponseFireAlertError(reason: reason)
        case ServerMessage.getSelectedCurrencies: print(json)
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

extension VinsoAPI: ReactiveCompatible {}
