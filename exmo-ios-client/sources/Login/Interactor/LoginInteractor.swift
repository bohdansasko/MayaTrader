//
//  LoginLoginInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import ObjectMapper
import SwiftyJSON
import Alamofire

class LoginInteractor  {
    weak var output: LoginInteractorOutput!
    var networkWorker: ILoginNetworkWorker!
    var loginModel: QRLoginModel?
}

// @MARK: LoginInteractorInput
extension LoginInteractor: LoginInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
    }
    
    func loadUserInfo(loginModel: QRLoginModel) {
        if !loginModel.isValidate() {
            output.showAlert(title: "Login", message: "QR doesn't validate")
            return
        }
        self.loginModel = loginModel
        networkWorker.loadUserInfo(loginModel: loginModel)
    }
}

// @MARK: ILoginNetworkWorkerDelegate
extension LoginInteractor: ILoginNetworkWorkerDelegate {
    func onDidLoadUserSuccessful(user: User) {
        AppDelegate.session.setUserModel(userData: user, shouldSaveUserInCache: true)
        output.closeViewController()
    }
    
    func onDidLoadUserFail(errorMessage: String?) {
        output.showAlert(title: "Login", message: errorMessage ?? "Undefined error")
    }
    
    
}
