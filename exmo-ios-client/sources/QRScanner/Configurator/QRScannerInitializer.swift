//
//  QRScannerQRScannerInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class QRScannerModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var qrScannerViewController: QRScannerViewController!

    override func awakeFromNib() {
        let configurator = QRScannerModuleConfigurator()
        configurator.configureModuleForViewInput(qrViewInput: qrScannerViewController)
    }

}
