//
//  QRScannerQRScannerInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import AVFoundation

class QRScannerInteractor: QRScannerInteractorInput {
    weak var output: QRScannerInteractorOutput!

    func tryFetchKeyAndSecret(metadataObjects: [AVMetadataObject]) {
        if metadataObjects.count > 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
                if object.type == AVMetadataObject.ObjectType.qr {
                    tryParseQRData(object.stringValue)
                }
            }
        }
    }
    
    private func tryParseQRData(_ strData: String?) {
        if let qrParsedStr = strData {
            let loginModel = QRLoginModel(qrParsedStr: qrParsedStr)
            output.setLoginData(loginModel: loginModel)
        }
    }
}
