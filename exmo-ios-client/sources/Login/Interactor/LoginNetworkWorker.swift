//
//  LoginNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/31/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire

protocol ILoginNetworkWorkerDelegate: class {
    func onDidLoadUserInfo(response: DataResponse<Any>)
}

protocol ILoginNetworkWorker {
    var delegate: ILoginNetworkWorkerDelegate! { get set }
    
    func loadUserInfo(loginModel: QRLoginModel)
}

class ExmoLoginNetworkWorker: ILoginNetworkWorker {
    var delegate: ILoginNetworkWorkerDelegate!
    
    func loadUserInfo(loginModel: QRLoginModel) {
        ExmoApiRequestBuilder.shared.setAuthorizationData(apiKey: loginModel.key, secretKey: loginModel.secret)
        
        let userInfoRequest = ExmoApiRequestBuilder.shared.getUserInfoRequest()
        Alamofire.request(userInfoRequest).responseJSON {
            [weak self] response in
            self?.delegate.onDidLoadUserInfo(response: response)
        }
    }
}
