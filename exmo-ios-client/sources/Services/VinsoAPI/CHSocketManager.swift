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

public enum CHWebSocketEvent {
    case connected
    case disconnected(Error?)
    case message(String)
    case data(Data)
    case pong
}

final class CHSocketManager {
    
    // MARK: - Private variables
    
    fileprivate var socket: WebSocket
    
    // MARK: - Public variables
    
    var connected = PublishSubject<Bool>()
    var response = PublishSubject<CHWebSocketEvent>()
    
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
    
    func connect() {
        socket.open()
    }
    
    func disconnect() {
        socket.close()
    }

    func send(message: JSON) {
        self.send(message: message.stringValue)
    }
    
    func send(message: String) {
        guard !message.isEmpty else {
            return
        }
        socket.send(text: message)
    }

}


private extension CHSocketManager {
    
    func subscribeOnSocketEvents() {
        socket.event.open = { [unowned self] in
            self.response.onNext(.connected)
            self.connected.onNext(true)
        }
        
        socket.event.close = { [unowned self] code, reason, clean in
            print("socket has been closed. details: code = \(code), reason = \(reason), wasClean\(clean)")
            self.response.onNext(.disconnected(nil))
            self.connected.onNext(false)
        }
        
        socket.event.message = { [unowned self] data in
            guard let message = data as? String else {
                return
            }
            print("message - \(message)")
            self.response.onNext(.message(message))
        }
        
        socket.event.error = { [unowned self] error in
            print("socket error: \(error)")
            self.response.onError(error)
        }
    }
    
}

//
extension CHSocketManager: ReactiveCompatible {}
