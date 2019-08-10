//
//  QRScannerQRScannerInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class QRScannerModuleInitializer: NSObject {
    @IBOutlet private(set) weak var viewController: QRScannerViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let configurator = QRScannerModuleConfigurator()
        configurator.configureModuleForViewInput(qrViewInput: viewController)
    }

}
