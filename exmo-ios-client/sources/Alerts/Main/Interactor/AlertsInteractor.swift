//
//  AlertsAlertsInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

class AlertsInteractor  {
    weak var output: AlertsInteractorOutput!
    var alertsNetworkWorker: IAlertsNetworkWorker!
}

extension AlertsInteractor: AlertsInteractorInput {
    func viewIsReady() {
        alertsNetworkWorker.delegate = self
    }
}

extension AlertsInteractor: IAlertsNetworkWorkerDelegate {
    func onDidLoadAlertsHistorySuccessful(_ w: ExmoWallet) {
        print("loaded alerts history")
    }
    
    func onDidLoadAlertsHistoryFail(messageError: String) {
        print(messageError)
    }
}
