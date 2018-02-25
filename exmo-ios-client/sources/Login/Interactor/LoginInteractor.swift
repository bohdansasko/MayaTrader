//
//  LoginLoginInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class LoginInteractor: LoginInteractorInput {
    weak var output: LoginInteractorOutput!
    
    func loadUserInfo(loginModel: QRLoginModel) {
        LoginService.sharedInstance.setUserInfo(apiKey: loginModel.key!, secretKey: loginModel.secret!)
        let result = LoginService.sharedInstance.userInfo()
        let dataString = String(data: result!, encoding: .utf8)

        print("loaded userInfo: \(dataString!)")
    }
}
