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
        if authorizedState.value == .connectedToSocket {
            assertionFailure("fix me")
            return
        }
        
        authorizedState.accept(.connectionToSocket)
        
        self.socketManager.connected.subscribe(
            onNext: { [unowned self] isConnected in
                self.authorizedState.accept(.connectedToSocket)
            })
            .disposed(by: self.disposeBag)
        
        self.socketManager.connect()
    }
    
    func connectToServer() {
        if self.authorizedState.value == .connectionToServer {
            assertionFailure("fix me")
            return
        }

        self.authorizedState.accept(.connectionToServer)
        
        let data = ["version_api" : kAPIVersion]
        let request = self.sendRequest(messageType: .connect, params: data)
        request.subscribe(onNext: { [unowned self] json in
            self.authorizedState.accept(.connectedToServer)
        }, onError: { [unowned self] err in
            self.authorizedState.accept(.notConnected)
            log.info(err.localizedDescription)
        }).disposed(by: self.disposeBag)
    }

    func disconnect() {
        isAuthorized = false
        log.info("disconnect")
        socketManager.disconnect()
    }
    
}

// MARK: - Manage user

extension VinsoAPI {
    
    func authorizeUser() {
        if self.authorizedState.value == .authorization {
            assertionFailure("fix me")
            return
        }
        
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        self.authorizedState.accept(.authorization)
        
        let params = ["udid": udid]
        self.sendRequest(messageType: .authorization, params: params)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] json in
                log.debug(json)
                self.authorizedState.accept(.authorizated)
            }, onError: { [unowned self] err in
                log.error(err.localizedDescription)
                self.authorizedState.accept(.notConnected)
            }).disposed(by: self.disposeBag)
    }
    
    func resetUser() {
        let msg = AccountApiRequestBuilder.buildResetUser()
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

extension Reactive where Base: VinsoAPI {

    func registerAPNSDeviceToken(_ deviceToken: String) -> Completable {
        let params: [String: Any] = [ "apns_token": deviceToken ]

        return self.base.sendRequest(messageType: .registerAPNsDeviceToken, params: params)
            .mapInBackground { json in
                log.info(json)
            }
            .asSingle()
            .asCompletable()
    }
    
}
