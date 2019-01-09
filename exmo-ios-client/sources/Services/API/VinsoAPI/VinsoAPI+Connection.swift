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
        print("\(String(describing: self)) => login")
        let msg = AccountApiRequestBuilder.buildAuthorizationRequest()
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