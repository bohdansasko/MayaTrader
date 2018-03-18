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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func viewIsReady(tableView: UITableView!) {
        displayManager.setTableView(tableView: tableView)

        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
    }

    func updateDisplayInfo() {
        displayManager.reloadData()
        output.setTouchEnabled(isTouchEnabled: displayManager.isDataExists())
    }
    
    func getWalletModelAsSegueBlock() -> SegueBlock? {
        return displayManager.getWalletModelAsSegueBlock()
    }
    
    func handleViewWillAppear() {
        displayManager.reloadData()
    }
}