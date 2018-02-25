//
//  LoginLoginViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol LoginViewOutput {

    /**
        @author TQ0oS
        Notify presenter that view is ready
    */

    func viewIsReady()
    func loadUserInfo(loginModel: QRLoginModel?)
}
