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
            guard let avObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
                      avObject.type == .qr,
                  let qrDataAsString = avObject.stringValue
            else {
                output.showAlert(title: "QR Scanner", message: "Sorry! Occur problem with QR. Please check if it's correct.", shouldCloseViewController: true)
                return
            }
            
            let qrModel = ExmoQRObject(qrParsedStr: qrDataAsString)
            if qrModel.isValidate() {
                output.setLoginData(loginModel: qrModel)
            } else {
                output.showAlert(title: "Login", message: "This is QR code doesn't relative to Exmo. Please, try another QR code.", shouldCloseViewController: false)
            }
        }
    }
}
