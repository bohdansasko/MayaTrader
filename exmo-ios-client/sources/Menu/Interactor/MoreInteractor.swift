//
//  MoreMenuInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit

class MenuInteractor: MenuInteractorInput {
    weak var output: MenuInteractorOutput!
    var dbManager: OperationsDatabaseProtocol!
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
}

// MARK: MenuInteractorInput
extension MenuInteractor {
    func viewIsReady() {
        subscribeOnEvents()
        
        if Defaults.isUserLoggedIn() {
            onUserSignIn()
        } else {
            onUserSignOut()
        }
    }

    func logout() {
        ExmoApiRequestBuilder.shared.clearAuthorizationData()
        Defaults.setUserLoggedIn(false)
        dbManager.clearAllData()
        AppDelegate.notificationController.postBroadcastMessage(name: .UserSignOut)
    }
}

// MARK: MenuInteractorInput
extension MenuInteractor {
    private func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserSignIn), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserSignOut), name: .UserSignOut)
    }
    
    @objc func onUserSignIn() {
        output.onUserLogInOut(isLoggedUser: true)
    }
    
    @objc func onUserSignOut() {
        output.onUserLogInOut(isLoggedUser: false)
    }
}
