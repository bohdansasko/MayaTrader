//
//  LoginLoginModuleInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 26/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol LoginModuleInput: class {
    // do nothing
}


protocol LoginModuleOutput: class {
     func setLoginData(loginModel: ExmoQRModel?)
}
