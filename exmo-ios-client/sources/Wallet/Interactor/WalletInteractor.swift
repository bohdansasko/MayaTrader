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
    var displayManager: WalletDisplayManager!
    
    init() {
        displayManager = WalletDisplayManager()
    }

    func viewIsReady(tableView: UITableView!) {
        displayManager.setTableView(tableView: tableView)

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
    }

    func updateDisplayInfo() {
        displayManager.updateInfo()
        output.setTouchEnabled(isTouchEnabled: displayManager.isDataExists())
    }
}
