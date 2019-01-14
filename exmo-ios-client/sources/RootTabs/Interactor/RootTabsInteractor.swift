//
//  Copyright © 2018 VinsoDev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Realm

class RootTabsInteractor {
    weak var output: RootTabsInteractorOutput!
    var networkWorker: ILoginNetworkWorker!
    var dbManager: OperationsDatabaseProtocol!
}

// MARK: RootTabsInteractorInput
extension RootTabsInteractor: RootTabsInteractorInput {
    func login() {
        networkWorker.delegate = self
        guard let user = dbManager.object(type: ExmoUserObject.self, key: ""),
              let qr = user.qr else {
            print("Can't load QR Code from cache")
            return
        }
        
        networkWorker.loadUserInfo(loginModel: ExmoQR(managedObject: qr))
    }
}

// MARK: ILoginNetworkWorkerDelegate
extension RootTabsInteractor: ILoginNetworkWorkerDelegate {
    func onDidLoadUserSuccessful(user: ExmoUser) {
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignIn)
    }
    
    func onDidLoadUserFail(errorMessage: String?) {
//        output.showAlert(title: "Login", message: errorMessage ?? "Undefined error")
        AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
    }
}
