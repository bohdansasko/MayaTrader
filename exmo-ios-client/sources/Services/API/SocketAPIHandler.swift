//
//  SocketApiHandler.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftWebSocket
import SwiftyJSON

class SocketApiHandler {
    private var socket: WebSocket!

    //
    // @MARK: callbacks
    //
    var callbackOnOpen: VoidClosure? = nil
    var callbackOnClose: ((_ code : Int, _ reason : String, _ wasClean : Bool) -> Void)? = nil
    var callbackOnMessage: ((_ data : Any) -> Void)? = nil
    var callbackOnError: ((_ error : Error) -> Void)? = nil

    //
    // @MARK: common methods
    //
    init(serverURL: String) {
        self.socket = WebSocket(serverURL)
        self.setSocketEvents()
    }

    deinit {
        self.disconnect()
    }

    //
    // @MARK: public methods
    //
    func connect(message: JSON) {
        self.socket.open()
        sendMessage(message: message)
    }

    func disconnect() {
        self.socket.close()
    }

    private func setSocketEvents() {
        self.socket.event.open = {
            print("socket connected")
            self.callbackOnOpen?()
        }

        self.socket.event.close = { code, reason, clean in
            print("socket close")
            self.callbackOnClose?(code, reason, clean)
        }

        self.socket.event.error = { error in
            print("socket error: \(error)")
            self.callbackOnError?(error)
        }

        self.socket.event.message = { message in
            self.callbackOnMessage?(message)
        }
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