//
//  AlertsNetworkProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Alamofire

protocol IAlertsNetworkWorkerDelegate: class {
    func onDidLoadAlertsHistorySuccessful(_ w: ExmoWallet)
    func onDidLoadAlertsHistoryFail(messageError: String)
}

protocol IAlertsNetworkWorker {
    var delegate: IAlertsNetworkWorkerDelegate! { get set }
    
    func loadHistory()
}
