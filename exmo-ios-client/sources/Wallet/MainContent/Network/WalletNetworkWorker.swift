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

class ExmoWalletNetworkWorker : IWalletNetworkWorker {
    weak var delegate: IWalletNetworkWorkerDelegate!
    
    func load() {
        let request = ExmoApiRequestBuilder.shared.getUserInfoRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            self?.onDidLoadWalletResponse(response)
        }
    }
    
    private func onDidLoadWalletResponse(_ response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                guard let data = response.data else {
                    delegate.onDidLoadWalletFail(messageError: "Problems with wallet incomed data")
                    return
                }
                let json = try JSON(data: data)
                guard let wallet = ExmoWallet(JSONString: json.description) else { return }
                delegate.onDidLoadWalletSuccessful(wallet)
            } catch {
                delegate.onDidLoadWalletFail(messageError: nil)
            }
        case .failure(_):
            delegate.onDidLoadWalletFail(messageError: nil)
        }
    }
}
