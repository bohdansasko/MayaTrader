//
//  CHExmoAuthorizationService.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/11/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHExmoAuthorizationService: NSObject {
    static let shared = CHExmoAuthorizationService()
    
    fileprivate var networkWorker: ILoginNetworkWorker        = ExmoLoginNetworkWorker()
    fileprivate var dbManager    : OperationsDatabaseProtocol = RealmDatabaseManager()
    
    private override init() {
        super.init()
        self.networkWorker.delegate = self
    }
    
}

// MARK: - LoginInteractorInput

extension CHExmoAuthorizationService {
    
    func login(by qr: ExmoQR) {
        if qr.isValidate() {
            networkWorker.loadUserInfo(loginModel: qr)
        }
    }
    
    /// try to fetch user from db and check if it was logged before
    func tryLogin() {
        guard let user = dbManager.object(type: ExmoUserObject.self, key: ""),
              let qr = user.qr else {
                print("\(#function) => Can't load QR Code from cache")
                return
        }
        let qrModel = ExmoQR(managedObject: qr)
        login(by: qrModel)
    }
 
    func logout() {
        ExmoApiRequestsBuilder.shared.clearAuthorizationData()
        Defaults.setUserLoggedIn(false)
        dbManager.clearAllData()
        NotificationCenter.default.post(name: AuthorizationNotification.userSignOut.name)
    }
    
}

// MARK: - ILoginNetworkWorkerDelegate

extension CHExmoAuthorizationService: ILoginNetworkWorkerDelegate {
    
    func onDidLoadUserSuccessful(user: ExmoUser) {
        let isNewUser = dbManager.object(type: ExmoUserObject.self, key: "") == nil
        if isNewUser {
            let wallet = ExmoWallet(id: user.wallet!.id,
                                    amountBTC: user.wallet!.amountBTC,
                                    amountUSD: user.wallet!.amountUSD,
                                    balances: user.wallet!.balances,
                                    favBalances: user.wallet!.balances,
                                    dislikedBalances: [])
            let newUser = ExmoUser(uid: user.uid, qr: user.qr, wallet: wallet)
            dbManager.add(data: newUser.managedObject(), update: true)
        }
        
        ExmoApiRequestsBuilder.shared.setAuthorizationData(apiKey: user.qr!.key, secretKey: user.qr!.secret)
        Defaults.setUserLoggedIn(true)
        NotificationCenter.default.post(name: AuthorizationNotification.userSignIn.name)
    }
    
    func onDidLoadUserFail(errorMessage: String?) {
        NotificationCenter.default.post(name: AuthorizationNotification.userFailSignIn.name,
                                        userInfo: [CHUserInfoKeys.reason.rawValue: errorMessage ?? "Undefined error"])
    }
    
}

// MARK: - UIApplicationDelegate

extension CHExmoAuthorizationService: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        tryLogin()
        return true
    }
    
}
