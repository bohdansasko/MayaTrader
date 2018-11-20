//
//  QRScannerQRScannerInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import AVFoundation

protocol QRScannerInteractorInput {
    func tryFetchKeyAndSecret(metadataObjects: [AVMetadataObject])
}

protocol QRScannerInteractorOutput: class {
    func setLoginData(loginModel: ExmoQRModel?)
    func showAlert(title: String, message: String, shouldCloseViewController: Bool)
}
