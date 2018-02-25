//
//  LoginLoginPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class LoginPresenter: LoginModuleInput, LoginViewOutput, LoginInteractorOutput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    
    func viewIsReady() {
        // do nothing
    }
    
    func setLoginData(block: QRLoginModel?) {
        view.setLoginData(configHolder: block)
        interactor.loadUserInfo(block: block)
    }
}
