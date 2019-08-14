//
// Created by Bogdan Sasko on 1/9/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift

struct ConnectionObservation {
    weak var observer: VinsoAPIConnectionDelegate?
}

// MARK: - Connection & disconnection with server

extension VinsoAPI {

    func establishConnection() {
        if isAuthorized { return }
        
        print("\(String(describing: self)) => establish connect")
        self.socketManager.connected.subscribe(onNext: { [unowned self] isConnected in
            if !isConnected {
                self.isAuthorized = false
                return
            }
            self.connectToServer()
        }).disposed(by: self.disposeBag)
        
        self.socketManager.connect()
    }
    
    func connectToServer() {
        if !socketManager.isOpen() {
            return
        }
        
        let request = self.sendRequest(messageType: .connect)
        request.subscribe(onNext: { json in
            self.connectionObservers.forEach({ $0.value.observer?.onConnectionOpened() })
            self.authorizeUser()
        }, onError: { err in
            print("\(#function) = \(err.localizedDescription)")
        }).disposed(by: self.disposeBag)
    }

    func disconnect() {
        isAuthorized = false
        print("\(String(describing: self)) => disconnect")
        socketManager.disconnect()
    }
    
}

// MARK: - Manage user

extension VinsoAPI {
    
    func authorizeUser() {
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        let params = ["udid": udid]
        self.sendRequest(messageType: .authorization, params: params)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] json in
                print("\(#function) = \(json)")
                self.isAuthorized = true
            }, onError: { [unowned self] err in
                print("\(#function) = \(err.localizedDescription)")
                self.isAuthorized = false
            }).disposed(by: self.disposeBag)
    }
    
    func resetUser() {
        let msg = AccountApiRequestBuilder.buildResetUser()
        socketManager.send(message: msg)
    }
    
    func registerAPNSDeviceToken(_ deviceToken: String) {
        print("\(String(describing: self)) => registerAPNSDeviceToken \(deviceToken)")
        let msg = AccountApiRequestBuilder.buildRegisterAPNSDeviceTokenRequest(deviceToken)
        socketManager.send(message: msg)
    }
    
}

// MARK: - Delegate connections

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
