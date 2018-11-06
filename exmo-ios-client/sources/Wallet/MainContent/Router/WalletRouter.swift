//
//  WalletWalletRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit.UIViewController

class WalletRouter: WalletRouterInput {
    func openCurrencyListVC(sourceVC: UIViewController) {
        let uiWalletList = UIStoryboard(name: "Wallet", bundle: nil).instantiateViewController(withIdentifier: WalletSegueIdentifiers.ManageCurrencies.rawValue) as! WalletSettingsViewController
        sourceVC.present(uiWalletList, animated: true, completion: nil)
    }
}
