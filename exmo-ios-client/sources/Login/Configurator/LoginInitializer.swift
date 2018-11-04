//
//  LoginLoginInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class LoginModuleInitializer {
    var viewController: LoginViewController
    
    init() {
        viewController = LoginViewController()
        
        let configurator = LoginModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
