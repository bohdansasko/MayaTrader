//
//  LoginLoginInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import ObjectMapper

class RequestError: Mappable {
    var result = false
    var error: String?
    
    required init?(map: Map) {
        if map.JSON["error"] == nil {
            return nil
        }
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        error <- map["error"]
    }
}

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
        
        let userModel = UserModel(JSONString: jsonString!)
        userModel?.qrModel = loginModel
        userModel?.walletInfo = WalletModel(JSONString: jsonString!)

        if userModel != nil {
            if DataService.cache.saveUserData(userModel: userModel!) {
                Session.sharedInstance.user = userModel!

                NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
                output.showTabMoreWithLoginData()
            }
        }
    }
}
