//
//  LoginLoginInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class LoginModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var loginViewController: LoginViewController!

    override func awakeFromNib() {

        let configurator = LoginModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: loginViewController)
    }

}
