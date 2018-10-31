//
//  LoginLoginPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class LoginPresenter: LoginModuleInput, LoginModuleOutput, LoginViewOutput, LoginInteractorOutput {
    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
}

// @MARK: LoginModuleInput
extension LoginPresenter {
    // do nothing
}

// @MARK: LoginModuleOutput
extension LoginPresenter {
    func setLoginData(loginModel: QRLoginModel?) {
        view.setLoginData(loginModel: loginModel)
    }
}

// @MARK: LoginViewOutput
extension LoginPresenter {
    func viewIsReady() {
        self.interactor.viewIsReady()
    }
    
    func loadUserInfo(loginModel: QRLoginModel) {
        interactor.loadUserInfo(loginModel: loginModel)
    }
    
    func prepareToOpenQRView(qrViewController: QRScannerViewController) {
        if let qrPresenter = qrViewController.outputProtocol as? QRScannerModuleInput {
            qrPresenter.setLoginPresenter(presenter: self)
        }
    }
    
    func showAlert(title: String, message: String) {
        view.showAlert(title: title, message: message)
    }
}

// @MARK: LoginInteractorOutput
extension LoginPresenter {
    func closeViewController() {
        router.closeViewController(view as! UIViewController)
    }
}
