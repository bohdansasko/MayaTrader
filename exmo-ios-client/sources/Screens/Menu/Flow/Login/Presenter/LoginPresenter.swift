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

// MARK: LoginModuleInput
extension LoginPresenter: LoginModuleInput {
    // do nothing
}

// MARK: LoginModuleOutput
extension LoginPresenter: LoginModuleOutput {
    func setLoginData(loginModel: ExmoQR?) {
        view.setLoginData(loginModel: loginModel)
    }
}

// MARK: LoginViewOutput
extension LoginPresenter: LoginViewOutput {
    func viewIsReady() {
        self.interactor.viewIsReady()
    }

    func loadUserInfo(loginModel: ExmoQR) {
        interactor.loadUserInfo(loginModel: loginModel)
    }

    func handleTouchOnScanQRButton() {
        if let viewController = view as? UIViewController {
            let qrScannerSegue = QRScannerSegueBlock(sourceVC: viewController, outputPresenter: self)
            router.showQRScannerVC(segueBlock: qrScannerSegue)
        }
    }

    func showAlert(title: String, message: String) {
        view.showAlert(title: title, message: message)
    }
}

// MARK: LoginInteractorOutput
extension LoginPresenter: LoginInteractorOutput {
    func closeViewController() {
        if let viewController = view as? UIViewController {
            router.closeViewController(viewController)
        }
    }
}
