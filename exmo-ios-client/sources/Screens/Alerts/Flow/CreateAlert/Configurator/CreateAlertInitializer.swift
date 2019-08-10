//
//  CreateAlertCreateAlertInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class CreateAlertModuleInitializer: NSObject {
    @IBOutlet fileprivate weak var viewController: CreateAlertViewController!

    override func awakeFromNib() {
        super.awakeFromNib()

        let configurator = CreateAlertModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
    
}
