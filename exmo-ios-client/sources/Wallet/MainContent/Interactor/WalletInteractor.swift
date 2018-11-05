//
//  WalletWalletInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit

class WalletInteractor: WalletInteractorInput {
    weak var output: WalletInteractorOutput!
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    func viewIsReady() {
        subscribeOnEvents()
    }
    
    private func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserSignOut)
    }
    
    @objc func updateDisplayInfo() {
//        displayManager.reloadData()
//        setTouchEnabled(isTouchEnabled: displayManager.isDataExists())
    }
}
