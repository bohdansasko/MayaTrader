//
//  WalletSettingsWalletSettingsViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UITableView

protocol WalletSettingsViewInput: class {
    
    /**
     @author TQ0oS
     Setup initial state of the view
     */
    
    func setupInitialState()
    func configure(walletModel: WalletModel)
}


protocol WalletSettingsViewOutput {

    /**
        @author TQ0oS
        Notify presenter that view is ready
    */
    
    func viewIsReady()
    func handleCloseView()
}
