//
//  TickerNetworkProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol ITickerNetworkWorkerDelegate: class {
    func onDidLoadTickerSuccess(_ ticker: Ticker?)
    func onDidLoadTickerFails()
}

protocol ITickerNetworkWorker: class {
    var delegate: ITickerNetworkWorkerDelegate? { get set }
    var isLoadCanceled: Bool {get}

    func load()
    func load(timeout: Double, repeat: Bool)
    func cancelRepeatLoads()
}
