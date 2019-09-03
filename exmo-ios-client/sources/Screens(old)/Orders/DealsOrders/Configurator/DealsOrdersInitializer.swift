//
//  DealsOrdersInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class DealsOrdersModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var historyordersViewController: DealsOrdersViewController!

    override func awakeFromNib() {

        let configurator = DealsOrdersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: historyordersViewController)
    }

}
