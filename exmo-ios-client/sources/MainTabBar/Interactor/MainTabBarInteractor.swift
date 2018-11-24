//
//  Copyright © 2018 VinsoDev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Realm

class MainTabBarInteractor {
    weak var output: MainTabBarInteractorOutput!
    var networkWorker: ILoginNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
}

// @MARK: MainTabBarInteractorInput
extension MainTabBarInteractor: MainTabBarInteractorInput {
    func login() {
        networkWorker.delegate = self
        guard let user = dbManager.object(type: ExmoUser.self, key: ""),
              let qr = user.qr else {
            print("Can't load QR Code from cache")
            return
        }
        
        networkWorker.loadUserInfo(loginModel: qr)
    }
}

// @MARK: ILoginNetworkWorkerDelegate
extension MainTabBarInteractor: ILoginNetworkWorkerDelegate {
    func onDidLoadUserSuccessful(user: ExmoUser) {
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignIn)
    }
    
    func onDidLoadUserFail(errorMessage: String?) {
//        output.showAlert(title: "Login", message: errorMessage ?? "Undefined error")
        AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
    }
}
