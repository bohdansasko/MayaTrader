//
//  WalletWalletInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var walletViewController: WalletViewController!

    override func awakeFromNib() {

        let configurator = WalletModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: walletViewController)
    }

}
