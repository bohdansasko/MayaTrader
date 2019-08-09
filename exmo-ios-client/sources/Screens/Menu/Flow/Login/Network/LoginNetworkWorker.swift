//
//  LoginNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/31/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ExmoLoginNetworkWorker: ILoginNetworkWorker {
    var delegate: ILoginNetworkWorkerDelegate!
    var loginModel: ExmoQR?
    
    func loadUserInfo(loginModel: ExmoQR) {
        print("Loading user info...")
        self.loginModel = loginModel
        ExmoApiRequestBuilder.shared.setAuthorizationData(apiKey: loginModel.key, secretKey: loginModel.secret)
        
        let userInfoRequest = ExmoApiRequestBuilder.shared.getUserInfoRequest()
        Alamofire.request(userInfoRequest).responseJSON {
            [weak self] response in
            self?.onDidLoadUserInfo(response: response)
        }
    }
    
    func onDidLoadUserInfo(response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                let json = try JSON(data: response.data!)
                if let requestError = ExmoResponseResult(JSONString: json.description) {
                    if requestError.error != nil {
                        delegate.onDidLoadUserFail(errorMessage: requestError.error)
                        return
                    }
                }
                guard let userInfoAsDictionary = json.dictionaryObject else { return }
                guard var userData = ExmoUser(JSON: userInfoAsDictionary) else {
                    delegate.onDidLoadUserFail(errorMessage: nil)
                    return
                }
                userData.qr = loginModel!
                delegate.onDidLoadUserSuccessful(user: userData)
            } catch {
                delegate.onDidLoadUserFail(errorMessage: nil)
            }
        case .failure(_):
            delegate.onDidLoadUserFail(errorMessage: nil)
        }
    }
}
