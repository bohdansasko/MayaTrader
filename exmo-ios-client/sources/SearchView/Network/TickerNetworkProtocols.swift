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
    func onDidLoadTickerFails(_ ticker: Ticker?)
}

protocol ITickerNetworkWorker: class {
    var delegate: ITickerNetworkWorkerDelegate? { get set }
    
    func load()
}
