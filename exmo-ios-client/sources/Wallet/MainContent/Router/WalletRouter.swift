//
//  WalletWalletRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UIViewController

class WalletRouter: WalletRouterInput {    
    func openWalletSettings(viewController: UIViewController, data: SegueBlock?) {
        viewController.openModule(segueIdentifier: WalletSegueIdentifiers.ManageCurrencies.rawValue, block: data)
    }
    
    func sendDataToWalletSettings(segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationController = segue.destination as? WalletSettingsViewController else { return }
        guard let walletSettingsPresenterIn = destinationController.output as? WalletSettingsModuleInput else { return }
        let segueBlock = sender as? SegueBlock
        let walletSegueBlock = segueBlock as? WalletSegueBlock

        walletSettingsPresenterIn.configure(walletModel: (walletSegueBlock?.dataProvider)!)
    }
    
}
