//
//  QRScannerQRScannerPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import AVFoundation

class QRScannerPresenter: QRScannerModuleInput, QRScannerViewOutput, QRScannerInteractorOutput {
    weak var view: QRScannerViewInput!
    var interactor: QRScannerInteractorInput!
    var router: QRScannerRouterInput!
    
    var loginPresenter: LoginModuleInput!
    
    func viewIsReady() {
        // do nothing
    }
    
    func tryFetchKeyAndSecret(metadataObjects: [AVMetadataObject]) {
        interactor.tryFetchKeyAndSecret(metadataObjects: metadataObjects)
    }
    
    func setLoginData(configBlock: QRLoginModel?) {
        loginPresenter.setLoginData(block: configBlock)
        view.dismissView()
    }
    
    func setLoginPresenter(presenter: LoginModuleInput) {
        loginPresenter = presenter
    }
}
