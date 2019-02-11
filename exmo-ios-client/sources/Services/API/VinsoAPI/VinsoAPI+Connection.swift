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
        if isAuthorized { return }
        print("\(String(describing: self)) => establish connect")
        socketManager.connect(message: AccountApiRequestBuilder.buildConnectRequest())
    }

    func disconnect() {
        isAuthorized = false
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

    func resetUser() {
        let msg = AccountApiRequestBuilder.buildResetUser()
        socketManager.sendMessage(message: msg)
    }

    func onSocketError(reason: String) {
        isAuthorized = false
        connectionObservers.forEach({ $0.value.observer?.onConnectionRefused(reason: "Can't establish connection. Please, try again through a few minutes or write us.") })
    }

    func onSocketClose(reason: String) {
        isAuthorized = false
        connectionObservers.forEach({ $0.value.observer?.onConnectionRefused(reason: "Your connection was interrupted. Please, try again through a few minutes or write us.") })
    }

    func setSubscriptionType(_ packageType: SubscriptionPackageType) {
        print("\(String(describing: self)) => \(#function)")
        let msg = AccountApiRequestBuilder.buildSetSubscriptionRequest(packageType.rawValue)
        socketManager.sendMessage(message: msg)
    }

    func loadAvailableSubscriptions() {
        print("\(String(describing: self)) => \(#function)")
        let msg = AccountApiRequestBuilder.buildGetSubscriptionConfigsRequest()
        socketManager.sendMessage(message: msg)
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
