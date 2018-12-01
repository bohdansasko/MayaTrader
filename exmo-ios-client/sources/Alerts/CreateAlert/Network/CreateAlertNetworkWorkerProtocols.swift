//
//  CreateAlertNetworkWorkerProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol ICreateAlertNetworkWorkerDelegate: class {
    func onDidCreateAlertSuccess()
    func onDidCreateAlertFail(errorMessage: String)
}

protocol ICreateAlertNetworkWorker: class {
    var delegate: ICreateAlertNetworkWorkerDelegate? { get set }
    
    func createAlert(_ alert: Alert)
}
