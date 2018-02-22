//
//  QRScannerQRScannerPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class QRScannerPresenter: QRScannerModuleInput, QRScannerViewOutput, QRScannerInteractorOutput {

    weak var view: QRScannerViewInput!
    var interactor: QRScannerInteractorInput!
    var router: QRScannerRouterInput!

    func viewIsReady() {

    }
}
