//
//  MainTabBarInteractor.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MainTabBarInteractor {
    weak var output: MainTabBarInteractorOutput!
    var networkWorker: ILoginNetworkWorker!
}

// @MARK: MainTabBarInteractorInput
extension MainTabBarInteractor: MainTabBarInteractorInput {
    func login() {
        networkWorker.delegate = self
        if AppDelegate.cacheController.isUserInfoExistsInCache() {
            guard let user = AppDelegate.cacheController.getUser(), let qrModel = user.qrModel else { return }
            networkWorker.loadUserInfo(loginModel: qrModel)
        }
    }
}

// @MARK: ILoginNetworkWorkerDelegate
extension MainTabBarInteractor: ILoginNetworkWorkerDelegate {
    func onDidLoadUserInfo(response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                let json = try JSON(data: response.data!)
                parseAndFinishLogin(json: json)
            } catch {
                print("NetworkWorker: we caught a problem in handle response")
            }
        case .failure(_):
            print("NetworkWorker: failure loading chart data")
        }
    }
}

extension MainTabBarInteractor {
    func parseAndFinishLogin(json: JSON) {
        if let requestError = RequestResult(JSONString: json.description) {
            if requestError.error != nil {
//                self.output.showAlert(title: "Login", message: requestError.error!)
                AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
                return
            }
        }
        guard let userInfoAsDictionary = json.dictionaryObject else { return }
        
        guard let user = User(JSON: userInfoAsDictionary) else {
//            output.showAlert(title: "Login", message: "Undefined error")
            AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
            return
        }
        user.qrModel = AppDelegate.cacheController.getUser()?.qrModel
        AppDelegate.session.setUserModel(userData: user, shouldSaveUserInCache: true)
    }
}

