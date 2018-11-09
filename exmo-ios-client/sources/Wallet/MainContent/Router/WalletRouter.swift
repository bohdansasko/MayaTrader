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
        let moduleInit = WalletSettingsModuleInitializer()
        sourceVC.present(moduleInit.viewController, animated: true, completion: nil)
    }
}
