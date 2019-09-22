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
        if authorizedState.value == .authorizated {
            return
        }

        if authorizedState.value == .connectionToSocket || self.socketManager.isConnecting() {
            return
        }
        
        if socketManager.isOpen() {
            log.info("User has been already connected to socket")
            authorizedState.accept(.connectedToSocket)
            return
        }

        authorizedState.accept(.connectionToSocket)
        self.socketManager.connect()
    }
    
    func connectToServer() {
        if self.authorizedState.value == .connectionToServer {
            return
        }
        
        if authorizedState.value == .connectedToServer {
            log.info("User has been already connected to server")
            self.authorizedState.accept(.connectedToServer)
            return
        }

        authorizedState.accept(.connectionToServer)
        log.info("sending request to connect to server")
        
        let data = ["version_api" : kAPIVersion]
        let request = self.sendRequest(messageType: .connect, params: data).asSingle()
        request.subscribe(onSuccess: { [unowned self] json in
            self.authorizedState.accept(.connectedToServer)
        }, onError: { [unowned self] err in
            log.info("error:", err.localizedDescription)
            self.authorizedState.accept(.notConnected)
        }).disposed(by: self.disposeBag)
    }

    func disconnect() {
        log.info("disconnect")
        socketManager.disconnect()
    }
    
}

// MARK: - Manage user

extension VinsoAPI {
    
    func authorizeUser() {
        if self.authorizedState.value == .authorization {
            return
        }
        
        if self.authorizedState.value == .authorizated {
            log.info("User has been already authorized")
            authorizedState.accept(.authorizated)
            return
        }
        
        guard let udid = UIDevice.current.identifierForVendor?.uuidString else {
            return
        }
        
        self.authorizedState.accept(.authorization)
        
        let udidHashStr = calculateAuthHash(from: udid)
        let params: [String : Any] = [
            "udid": udid,
            "hash": udidHashStr
        ]
        self.sendRequest(messageType: .authorization, params: params)
            .asSingle()
            .subscribe(onSuccess: { [unowned self] json in
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
    
    fileprivate func calculateAuthHash(from deviceToken: String) -> UInt64 {
        var hash: UInt64 = 0
        deviceToken.enumerated().forEach{ (it) in
            let (i, currentCh) = it
            if currentCh.isLetter || currentCh.isNumber {
                let index = deviceToken.index(deviceToken.startIndex, offsetBy: deviceToken.count - i - 1)
                let offsetCh = deviceToken[index]
                
                let res = UInt64(currentCh.asciiValue! ^ (offsetCh.asciiValue! | 0xA9))
                let offset = UInt64((i % MemoryLayout.size(ofValue: hash)) * 8)
                
                hash ^= res << offset
            }
        }
        
        return hash
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

// MARK: - Reactive VinsoAPI

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
