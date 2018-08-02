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
        
        AppDelegate.exmoController.setUserLoginData(apiKey: loginModel.key!, secretKey: loginModel.secret!)
        AppDelegate.session.login(serverType: .Exmo)
        
        let result = AppDelegate.exmoController.loadUserInfo()
        let jsonString = String(data: result!, encoding: .utf8)
        print("loaded userInfo: \(jsonString!)")
        
        if let requestError = RequestError(JSONString: jsonString!) {
            print("qr data doesn't validate: \(requestError.error!)")
            return
        }
        
        let user = User(JSONString: jsonString!)
        if let walletInfo = WalletModel(JSONString: jsonString!) {
            user?.walletInfo = walletInfo
        }
        user?.qrModel = loginModel

        if user != nil {
            let isUserDataSaved = CacheManager.sharedInstance.userCoreManager.saveUserData(user: user!)
            if isUserDataSaved {
                AppDelegate.session.updateUserInfo(userData: user!)
                AppDelegate.notificationController.postBroadcastMessage(name: .UserSignIn)
                output.emitCloseView()
            }
        }
    }
}
