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
    var dbManager: OperationsDatabaseProtocol!
}

// MARK: LoginInteractorInput
extension LoginInteractor: LoginInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
    }
    
    func loadUserInfo(loginModel: ExmoQR) {
        if !loginModel.isValidate() {
            output.showAlert(title: "Login", message: "QR doesn't validate")
            return
        }
        networkWorker.loadUserInfo(loginModel: loginModel)
    }
}

// MARK: ILoginNetworkWorkerDelegate
extension LoginInteractor: ILoginNetworkWorkerDelegate {
    func onDidLoadUserSuccessful(user: ExmoUser) {
        dbManager.add(data: user.managedObject(), update: true)
        Defaults.setUserLoggedIn(true)
        NotificationCenter.default.post(name: .UserSignIn)
        output.closeViewController()
    }
    
    func onDidLoadUserFail(errorMessage: String?) {
        NotificationCenter.default.post(name: .UserFailSignIn)
        output.showAlert(title: "Login", message: errorMessage ?? "Undefined error")
    }
}
