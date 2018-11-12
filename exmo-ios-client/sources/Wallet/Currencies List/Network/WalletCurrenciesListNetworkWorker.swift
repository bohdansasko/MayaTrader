//
//  WalletCurrenciesListNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol IWalletCurrenciesListNetworkWorkerDelegate: class {
    func onDidLoadWalletInfo(response: DataResponse<Any>)
}

protocol IWalletCurrenciesListNetworkWorker {
    var delegate: IWalletCurrenciesListNetworkWorkerDelegate! { get set }
    
    func loadWalletInfo()
}

class ExmoWalletCurrenciesListNetworkWorker : IWalletCurrenciesListNetworkWorker {
    var delegate: IWalletCurrenciesListNetworkWorkerDelegate!
    
    func loadWalletInfo() {
        let request = ExmoApiRequestBuilder.shared.getUserInfoRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            self?.delegate.onDidLoadWalletInfo(response: response)
        }
    }
}

