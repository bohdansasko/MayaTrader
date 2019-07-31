//
//  CHSocketService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/30/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift
import Starscream
import RxStarscream

final class CHSocketService {
    fileprivate let disposeBag = DisposeBag()
    fileprivate var socket: WebSocket!
    fileprivate var plistConfig: PListFile<ConfigInfoPList> = {
        return try! PListFile<ConfigInfoPList>()
    }()
    
    init() {
        initSocket()
    }
    
    func initSocket() {
        let endpointUrl = self.plistConfig.model.configuration.endpoint
        print("Init socket with url \(endpointUrl)")
        self.socket = WebSocket(url: URL(string: endpointUrl)!)
        self.socket.connect()
        self.socket.rx.response.subscribe(onNext: { socketEvent in
            switch socketEvent {
            case .connected:
                print("connected")
            case .disconnected(let err):
                print("disconnected - \(err?.localizedDescription ?? "")")
            case .message(let message):
                print("message - \(message)")
            case .data(let d):
                print("data - \(d)")
            case .pong:
                print("pong")
            }
        })
        .disposed(by: disposeBag)
    }
}
