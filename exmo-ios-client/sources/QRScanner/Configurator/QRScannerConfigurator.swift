//
//  QRScannerQRScannerConfigurator.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class QRScannerModuleConfigurator {

    func configureModuleForViewInput<UIViewController>(viewInput: UIViewController) {

        if let viewController = viewInput as? QRScannerViewController {
            configure(viewController: viewController)
        }
    }

    private func configure(viewController: QRScannerViewController) {

        let router = QRScannerRouter()

        let presenter = QRScannerPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = QRScannerInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }

}
