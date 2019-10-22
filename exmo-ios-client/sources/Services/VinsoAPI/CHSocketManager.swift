//
//  CHSocketManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftWebSocket
import SwiftyJSON
import RxSwift

enum CHWebSocketEvent {
    case connected
    case disconnected(Error?)
    case message(String)
    case data(Data)
    case pong
}

final class CHSocketManager {
    
    // MARK: - Private variables
    
    fileprivate var socket: WebSocket
    fileprivate let disposeBag = DisposeBag()
    
    // MARK: - Public variables
    
    fileprivate(set) var connected = PublishSubject<Bool>()
    fileprivate(set) var response = PublishSubject<CHWebSocketEvent>()
    
    init(serverURL: String) {
        socket = WebSocket(serverURL)
        socket.allowSelfSignedSSL = true
        subscribeOnSocketEvents()
    }

    deinit {
        disconnect()
    }

}

extension CHSocketManager {
    
    func isOpen() -> Bool {
        return socket.readyState == .open
    }
    
    func isConnecting() -> Bool {
        return socket.readyState == .connecting
    }
    
}

extension CHSocketManager {
    
    func autoconnect(timeout: TimeInterval) -> Single<Void> {
        return Observable<Void>.create{ [unowned self] s in
                log.info("trying to open socket")
                self.connect()
                let subscription = self.connected
                    .distinctUntilChanged()
                    .subscribe(onNext: { isConnected in
                        log.info(isConnected)
                        if isConnected {
                            s.onNext(())
                            s.onCompleted()
                        } else {
                            s.onError(CHVinsoAPIError.noConnection)
                        }
                    })
                return Disposables.create {
                    subscription.dispose()
                }
            }
            .retry(withTimeout: timeout)
            .asSingle()
    }
    
    func connect() {
        socket.open()
    }
    
    func disconnect() {
        self.socket.close()
        self.response.onNext(.disconnected(CHVinsoAPIError.noConnection))
        self.connected.onNext(false)
    }

}

extension CHSocketManager {
        
    func send(message: JSON) {
        self.send(message: message.stringValue)
    }
    
    func send(message: String) {
        if message.isEmpty {
            assertionFailure("fix me")
            return
        }
        
        if isOpen() {
            socket.send(text: message)
        }
    }

}


private extension CHSocketManager {
    
    func subscribeOnSocketEvents() {
        socket.event.open = { [unowned self] in
            self.response.onNext(.connected)
            self.connected.onNext(true)
        }
        
        socket.event.close = { [unowned self] code, reason, clean in
            log.debug("socket has been closed. details: code = \(code), reason = \(reason), wasClean\(clean)")
            self.response.onNext(.disconnected(CHVinsoAPIError.noConnection))
            self.connected.onNext(false)
        }
        
        socket.event.message = { [unowned self] data in
            guard let message = data as? String else {
                return
            }
            self.response.onNext(.message(message))
        }
        
        socket.event.error = { error in
            log.debug("socket error: \(error)")            
        }
    }
    
}

// MARK: - ReactiveCompatible

extension CHSocketManager: ReactiveCompatible {
    // do nothing
}
