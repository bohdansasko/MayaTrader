//
//  LoginLoginInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class LoginModuleInitializer: NSObject {
    @IBOutlet weak var viewController: LoginViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let configurator = LoginModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: viewController)
    }
}
