//
//  QRScannerQRScannerInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class QRScannerModuleInitializer {
    lazy var qrScannerViewController = QRScannerViewController()

    init() {
        let configurator = QRScannerModuleConfigurator()
        configurator.configureModuleForViewInput(qrViewInput: qrScannerViewController)
    }

}
