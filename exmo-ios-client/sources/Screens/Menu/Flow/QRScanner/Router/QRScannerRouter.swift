//
//  QRScannerQRScannerRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class QRScannerRouter: QRScannerRouterInput {
    weak var viewController: QRScannerViewController!
    
    func closeViewController(_ vc: UIViewController) {
        vc.close()
    }
}
