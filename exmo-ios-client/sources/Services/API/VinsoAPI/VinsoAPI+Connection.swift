//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

struct ConnectionObservation {
    weak var observer: VinsoAPIConnectionDelegate?
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
        connectionObservers.forEach({ $0.value.observer?.onConnectionOpened() })
        print("\(String(describing: self)) => login")
        let msg = AccountApiRequestBuilder.buildAuthorizationRequest()
        socketManager.sendMessage(message: msg)
    }

    func registerAPNSDeviceToken(_ deviceToken: String) {
        print("\(String(describing: self)) => registerAPNSDeviceToken \(deviceToken)")
        let msg = AccountApiRequestBuilder.buildRegisterAPNSDeviceTokenRequest(deviceToken)
        socketManager.sendMessage(message: msg)
    }

    func onSocketError(reason: String) {
        isLogined = false
        connectionObservers.forEach({ $0.value.observer?.onConnectionRefused(reason: "Can't establish connection. Please, try again through a few minutes or write us.") })
    }

    func onSocketClose(reason: String) {
        isLogined = false
        connectionObservers.forEach({ $0.value.observer?.onConnectionRefused(reason: "Your connection was interrupted. Please, try again through a few minutes or write us.") })
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