//
//  WalletNetworkProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Alamofire

protocol IWalletNetworkWorkerDelegate: class {
    func onDidLoadWalletSuccessful(_ w: ExmoWallet)
    func onDidLoadWalletFail(messageError: String?)
}

protocol IWalletNetworkWorker {
    var delegate: IWalletNetworkWorkerDelegate! { get set }

    func load()
}
