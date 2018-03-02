//
//  WalletCoreDataEngine.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/2/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class WalletCoreDataEngine {
    static var sharedInstance = WalletCoreDataEngine()
    private var walletData = WalletDataProvider()
    
    func getWallet() -> WalletDataProvider {
        return walletData
    }
}
