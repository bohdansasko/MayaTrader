//
//  LoginLoginInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import ObjectMapper

class LoginInteractor: LoginInteractorInput {
    weak var output: LoginInteractorOutput!
    
    func loadUserInfo(loginModel: QRLoginModel) {
        if !loginModel.isValidate() {
            print("qr data doent's validate")
            return
        }
        APIService.sharedInstance.setUserInfo(apiKey: loginModel.key!, secretKey: loginModel.secret!)
        let result = APIService.sharedInstance.userInfo()

        let jsonString = String(data: result!, encoding: .utf8)
        print("loaded userInfo: \(jsonString!)")
        
        if let requestError = RequestError(JSONString: jsonString!) {
            print("qr data doesn't validate: \(requestError.error!)")
            return
        }
        
        let user = User(JSONString: jsonString!)
        user?.walletInfo = WalletModel(JSONString: jsonString!)
        user?.qrModel = loginModel

        if user != nil {
            let isUserDataSaved = CacheManager.sharedInstance.userCoreManager.saveUserData(user: user!)
            if isUserDataSaved {
                Session.sharedInstance.user = user!

                NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
                output.showTabMoreWithLoginData()
            }
        }
    }
}
