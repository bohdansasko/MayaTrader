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
    func onDidLoadUserSuccessful(user: User) {
        AppDelegate.session.setUserModel(userData: user, shouldSaveUserInCache: true)
    }
    
    func onDidLoadUserFail(errorMessage: String?) {
//        output.showAlert(title: "Login", message: errorMessage ?? "Undefined error")
        AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
    }
}
