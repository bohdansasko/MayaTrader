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

    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }

    func tryLogin() {
        guard let user = dbManager.object(type: ExmoUserObject.self, key: ""),
              let qr = user.qr else {
            print("\(#function) => Can't load QR Code from cache")
            return
        }
        print("\(#function) => loadUserInfo()")
        networkWorker.loadUserInfo(loginModel: ExmoQR(managedObject: qr))
    }
}

// MARK: RootTabsInteractorInput
extension RootTabsInteractor: RootTabsInteractorInput {
    func viewDidLoad() {
        networkWorker.delegate = self

        IAPService.shared.fetchAllSubscriptions()
        tryLogin()
    }

    func viewWillAppear() {
        // do nothing
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
