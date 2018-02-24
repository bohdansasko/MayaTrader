//
//  QRScannerQRScannerViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import AVFoundation

protocol QRScannerViewOutput {
    func viewIsReady()
    func tryFetchKeyAndSecret(metadataObjects: [AVMetadataObject])
    func setLoginPresenter(presenter: LoginModuleInput)
}
