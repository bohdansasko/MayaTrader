//
//  LoginLoginViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol LoginViewOutput {
    func viewIsReady()
    func loadUserInfo(loginModel: QRLoginModel?)
    func prepareToOpenQRView(qrViewController: QRScannerViewController)
    func handlePressedCloseBtn()
}
