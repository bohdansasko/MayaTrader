//
//  SocketManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftWebSocket
import SwiftyJSON

class SocketManager {
    private var socket: WebSocket!

    var callbackOnOpen: VoidClosure?
    var callbackOnClose: ((_ code : Int, _ reason : String, _ wasClean : Bool) -> Void)?
    var callbackOnMessage: ((_ data : Any) -> Void)?
    var callbackOnError: ((_ error : Error) -> Void)?

    init(serverURL: String) {
        socket = WebSocket(serverURL)
        socket.allowSelfSignedSSL = true
        setSocketEvents()
    }

    deinit {
        disconnect()
    }

    func isOpen() -> Bool {
        return socket.readyState == .open
    }

    func isConnecting() -> Bool {
        return socket.readyState == .connecting
    }
}

extension SocketManager {
    func connect(message: JSON) {
        socket.open()
        sendMessage(message: message)
    }
    
    func disconnect() {
        socket.close()
    }
    
    func sendMessage(message: JSON) {
        guard let msg = message.rawString() else {
            return
        }
        
        if !msg.isEmpty {
            print("send message to server: " + msg)
            socket.send(text: msg)
        }
    }
}


extension SocketManager {
    func setSocketEvents() {
        socket.event.open = {
            print("socket connected")
            self.callbackOnOpen?()
        }
        
        socket.event.close = { code, reason, clean in
            print("socket has closed. details: code = \(code), reason = \(reason), wasClean\(clean)")
            self.callbackOnClose?(code, reason, clean)
        }
        
        socket.event.error = { error in
            print("socket error: \(error)")
            self.callbackOnError?(error)
        }
        
        socket.event.message = { message in
            self.callbackOnMessage?(message)
        }
    }
}
