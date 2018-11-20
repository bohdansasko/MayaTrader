//
//  LoginLoginPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class LoginPresenter {
    weak var view: LoginViewInput!
    var interactor: LoginInteractorInput!
    var router: LoginRouterInput!
}

// @MARK: LoginModuleInput
extension LoginPresenter: LoginModuleInput {
    // do nothing
}

// @MARK: LoginModuleOutput
extension LoginPresenter: LoginModuleOutput {
    func setLoginData(loginModel: ExmoQRModel?) {
        view.setLoginData(loginModel: loginModel)
    }
}

// @MARK: LoginViewOutput
extension LoginPresenter: LoginViewOutput {
    func viewIsReady() {
        self.interactor.viewIsReady()
    }

    func loadUserInfo(loginModel: ExmoQRModel) {
        interactor.loadUserInfo(loginModel: loginModel)
    }

    func handleTouchOnScanQRButton() {
        let qrScannerSegue = QRScannerSegueBlock(sourceVC: view as! UIViewController, outputPresenter: self)
        router.showQRScannerVC(segueBlock: qrScannerSegue)
    }

    func showAlert(title: String, message: String) {
        view.showAlert(title: title, message: message)
    }
}

// @MARK: LoginInteractorOutput
extension LoginPresenter: LoginInteractorOutput {
    func closeViewController() {
        router.closeViewController(view as! UIViewController)
    }
}
