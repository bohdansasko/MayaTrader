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

    func viewIsReady() {
        subscribeOnEvents()
        onUserLogInOut()
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    private func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserLogInOut), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onUserLogInOut), name: .UserSignOut)
    }
    
    @objc func onUserLogInOut() {
        output.onUserLogInOut(isLoggedUser: AppDelegate.session.isExmoAccountExists())
    }
}
