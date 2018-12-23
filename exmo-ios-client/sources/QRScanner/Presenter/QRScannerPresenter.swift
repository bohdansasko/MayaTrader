//
//  QRScannerQRScannerPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit
import AVFoundation

class QRScannerPresenter: QRScannerModuleInput, QRScannerViewOutput, QRScannerInteractorOutput {
    weak var view: QRScannerViewInput!
    var interactor: QRScannerInteractorInput!
    var router: QRScannerRouterInput!
    var loginPresenter: LoginModuleOutput!
}

// @MARK: QRScannerModuleInput
extension QRScannerPresenter {
    func setLoginPresenter(presenter: LoginModuleOutput) {
        loginPresenter = presenter
    }
}

// @MARK: QRScannerViewOutput
extension QRScannerPresenter {
    func viewIsReady() {
        // do nothing
    }
    
    func tryFetchKeyAndSecret(metadataObjects: [AVMetadataObject]) {
        interactor.tryFetchKeyAndSecret(metadataObjects: metadataObjects)
    }
    
    func closeViewController() {
        router.closeViewController(view as! UIViewController)
    }
}

// @MARK: QRScannerInteractorOutput
extension QRScannerPresenter {
    func setLoginData(loginModel: ExmoQRObject?) {
        loginPresenter.setLoginData(loginModel: loginModel)
        closeViewController()
    }
    
    func showAlert(title: String, message: String, shouldCloseViewController: Bool) {
        view.showAlert(title: title, message: message, shouldCloseViewController: shouldCloseViewController)
    }
}
