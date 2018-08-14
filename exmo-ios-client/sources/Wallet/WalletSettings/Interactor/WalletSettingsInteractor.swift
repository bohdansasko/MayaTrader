//
//  WalletSettingsWalletSettingsInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class WalletSettingsInteractor: WalletSettingsInteractorInput {
    weak var output: WalletSettingsInteractorOutput!
    
    func viewIsReady() {
        // do nothing
    }

    func saveWalletDataToCache() {
        print("WalletSettingsInteractor: save wallet to cache")
        let isUserSavedToLocalStorage = AppDelegate.cacheController.userCoreManager.saveUserData(user: AppDelegate.session.getUser())
        if isUserSavedToLocalStorage {
            print("user info cached")
        }
    }
}
