//
//  File.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/6/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol IWalletNetworkWorkerDelegate: class {
    func onDidLoadWalletInfo(response: DataResponse<Any>)
    func onDidLoadTicker(response: DataResponse<Any>)
}

protocol IWalletNetworkWorker {
    func loadWalletInfo()
    func loadTicker()
    
    var delegate: IWalletNetworkWorkerDelegate! { get set }
}

class ExmoWalletNetworkWorker : IWalletNetworkWorker {
    weak var delegate: IWalletNetworkWorkerDelegate!
    
    func loadWalletInfo() {
        let request = ExmoApiRequestBuilder.shared.getUserInfoRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            self?.delegate.onDidLoadWalletInfo(response: response)
        }
    }
    
    func loadTicker() {
        let request = ExmoApiRequestBuilder.shared.getTickerRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            self?.delegate.onDidLoadTicker(response: response)
        }
    }
}
