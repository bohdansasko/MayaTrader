//
//  WalletSettingsWalletSettingsInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WalletSettingsModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var walletsettingsViewController: WalletSettingsViewController!

    override func awakeFromNib() {

        let configurator = WalletSettingsModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: walletsettingsViewController)
    }

}
