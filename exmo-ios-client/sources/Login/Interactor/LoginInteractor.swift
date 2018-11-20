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

// @MARK: LoginInteractorInput
extension LoginInteractor: LoginInteractorInput {
    func viewIsReady() {
        networkWorker.delegate = self
    }
    
    func loadUserInfo(loginModel: ExmoQRModel) {
        if !loginModel.isValidate() {
            output.showAlert(title: "Login", message: "QR doesn't validate")
            return
        }
        networkWorker.loadUserInfo(loginModel: loginModel)
    }
}

// @MARK: ILoginNetworkWorkerDelegate
extension LoginInteractor: ILoginNetworkWorkerDelegate {
    func onDidLoadUserSuccessful(user: ExmoUser) {
        dbManager.add(data: user, update: true)
        Defaults.setUserLoggedIn(true)
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignIn)
        output.closeViewController()
    }
    
    func onDidLoadUserFail(errorMessage: String?) {
        AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
        output.showAlert(title: "Login", message: errorMessage ?? "Undefined error")
    }
}
