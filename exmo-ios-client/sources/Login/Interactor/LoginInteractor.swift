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

extension LoginInteractor {
    func parseAndFinishLogin(json: JSON) {
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

// @MARK: ILoginNetworkWorkerDelegate
extension LoginInteractor: ILoginNetworkWorkerDelegate {
    func onDidLoadUserInfo(response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                let jsonStr = try JSON(data: response.data!)
                parseAndFinishLogin(json: jsonStr)
            } catch {
                print("NetworkWorker: we caught a problem in handle response")
            }
        case .failure(_):
            print("NetworkWorker: failure loading chart data")
        }
    }
}
