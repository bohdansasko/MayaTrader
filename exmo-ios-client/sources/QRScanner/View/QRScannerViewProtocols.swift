//
//  QRScannerQRScannerViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import AVFoundation

protocol QRScannerViewInput: class {
    func setupInitialState()
    func showAlert(title: String, message: String, shouldCloseViewController: Bool)
}

protocol QRScannerViewOutput {
    func viewIsReady()
    func tryFetchKeyAndSecret(metadataObjects: [AVMetadataObject])
    func closeViewController()
}
