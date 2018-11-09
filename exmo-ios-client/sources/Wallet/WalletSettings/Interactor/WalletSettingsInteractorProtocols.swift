//
//  WalletSettingsWalletSettingsInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol WalletSettingsInteractorInput {
    func viewIsReady()
    func saveWalletDataToCache()
}

protocol WalletSettingsInteractorOutput: class {
    // do nothing
}
