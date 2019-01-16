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
        subscribeOnIAPEvents()

        IAPService.shared.fetchAllSubscriptions()
        // tryLogin()
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


extension RootTabsInteractor {
    func subscribeOnIAPEvents() {
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseSuccess(_ :)),
                name: IAPService.Notification.purchased.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseError(_ :)),
                name: IAPService.Notification.expired.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseError(_ :)),
                name: IAPService.Notification.notPurchased.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseSuccess(_ :)),
                name: IAPService.Notification.purchaseSuccess.name)
        AppDelegate.notificationController.addObserver(
                self,
                selector: #selector(onProductPurchaseError(_ :)),
                name: IAPService.Notification.purchaseError.name)
    }

    func unsubscribeEvents() {
        AppDelegate.notificationController.removeObserver(self)
    }
}


extension RootTabsInteractor {
    @objc
    func onProductPurchaseSuccess(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
    }

    @objc
    func onProductPurchaseError(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let product = notification.userInfo?[IAPService.kProductNotificationKey] as? IAPProduct else {
            print("\(String(describing: self)), \(#function) => can't convert notification container to IAPProduct")
            return
        }
        print("\(String(describing: self)), \(#function) => notification IAPProduct is \(product.rawValue)")
    }
}
