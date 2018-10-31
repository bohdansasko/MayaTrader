//
//  LoginNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/31/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire

protocol ILoginNetworkWorker : NetworkWorker {
    func loadUserInfo(loginModel: QRLoginModel)
}

class LoginNetworkWorker : ILoginNetworkWorker {
    
    var onHandleResponseSuccesfull: ((Any) -> Void)?
    
    func loadUserInfo(loginModel: QRLoginModel) {
        ExmoApiRequestBuilder.shared.setAuthorizationData(apiKey: loginModel.key, secretKey: loginModel.secret)
        
        let userInfoRequest = ExmoApiRequestBuilder.shared.getUserInfoRequest()
        Alamofire.request(userInfoRequest).responseJSON {
            response in
            self.handleResponse(response: response)
        }
    }
}
