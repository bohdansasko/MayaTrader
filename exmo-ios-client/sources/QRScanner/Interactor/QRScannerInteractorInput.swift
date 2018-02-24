//
//  QRScannerQRScannerInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import AVFoundation

protocol QRScannerInteractorInput {
    func tryFetchKeyAndSecret(metadataObjects: [AVMetadataObject])
}
