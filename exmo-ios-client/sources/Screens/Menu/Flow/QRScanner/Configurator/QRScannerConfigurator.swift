//
//  QRScannerQRScannerConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class QRScannerModuleConfigurator {
    func configureModuleForViewInput<UIViewController>(qrViewInput: UIViewController) {
        guard let qrScannerViewController = qrViewInput as? QRScannerViewController else { return }

        configure(qrScannerViewController: qrScannerViewController)
    }

    private func configure(qrScannerViewController: QRScannerViewController) {
        let router = QRScannerRouter()
        router.viewController = qrScannerViewController
        
        let presenter = QRScannerPresenter()
        presenter.view = qrScannerViewController
        presenter.router = router
        
        let interactor = QRScannerInteractor()
        interactor.output = presenter
        presenter.interactor = interactor
        
        qrScannerViewController.outputProtocol = presenter
    }

}
