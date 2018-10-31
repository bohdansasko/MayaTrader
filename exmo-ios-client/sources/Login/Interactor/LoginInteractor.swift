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

class LoginInteractor: LoginInteractorInput {
    weak var output: LoginInteractorOutput!
    var networkWorker: ILoginNetworkWorker!
    var loginModel: QRLoginModel?
    
    func viewIsReady() {
        networkWorker.onHandleResponseSuccesfull = {
            [weak self] response in
            self?.onDidLoadUserInfo(response: response)
        }
    }
    
    func loadUserInfo(loginModel: QRLoginModel) {
        if !loginModel.isValidate() {
            output.showAlert(title: "Login", message: "QR doesn't validate")
            return
        }
        self.loginModel = loginModel
        networkWorker.loadUserInfo(loginModel: loginModel)
    }
    
    func onDidLoadUserInfo(response: Any) {
        guard let json = response as? JSON else { return }
        if let requestError = RequestResult(JSONString: json.description) {
            if requestError.error != nil {
                self.output.showAlert(title: "Login", message: requestError.error!)
                AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
                return
            }
        }
        guard let userInfoAsDictionary = json.dictionaryObject else { return }
        
        guard let userData = User(JSON: userInfoAsDictionary) else {
            output.showAlert(title: "Login", message: "Undefined error")
            AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
            return
        }
        userData.qrModel = loginModel
        loginModel = nil
        
        AppDelegate.session.setUserModel(userData: userData, shouldSaveUserInCache: true)
        output.closeViewController()
    }
}
