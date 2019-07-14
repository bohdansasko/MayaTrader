//
//  CurrenciesGroupsInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CurrenciesGroupsModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet var viewController: CurrenciesGroupsViewController!

    override func awakeFromNib() {

        let configurator = CurrenciesGroupsModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }

}
