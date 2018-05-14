//
//  CreateAlertCreateAlertInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var createalertViewController: CreateAlertViewController!

    override func awakeFromNib() {

        let configurator = CreateAlertModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: createalertViewController)
    }

}
