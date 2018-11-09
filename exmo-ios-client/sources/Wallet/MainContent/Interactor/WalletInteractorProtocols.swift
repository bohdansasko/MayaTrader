//
//  WalletWalletInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UITableView

@objc protocol WalletInteractorInput {
    func viewDidLoad()
    func viewIsReady()
}

protocol WalletInteractorOutput: class {
    func onDidLoadWallet(_ wallet: WalletModel)
}