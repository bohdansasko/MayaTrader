//
//  LoginLoginViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol LoginViewInput: class {
    func setupInitialState()
    func setLoginData(loginModel: QRLoginModel?)
}
