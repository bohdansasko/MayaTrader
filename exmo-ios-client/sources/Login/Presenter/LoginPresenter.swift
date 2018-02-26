//
//  LoginLoginPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class LoginPresenter: LoginModuleInput, LoginModuleOutput, LoginViewOutput, LoginInteractorOutput {

    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
    
    func viewIsReady() {
        // do nothing
    }
    
    func setLoginData(loginModel: QRLoginModel?) {
        view.setLoginData(loginModel: loginModel)
    }

    func loadUserInfo(loginModel: QRLoginModel?) {
        interactor.loadUserInfo(loginModel: loginModel!)
    }

    func prepareToOpenQRView(qrViewController: QRScannerViewController) {
        if let qrPresenter = qrViewController.outputProtocol as? QRScannerModuleInput {
            qrPresenter.setLoginPresenter(presenter: self)
        }
    }
}
