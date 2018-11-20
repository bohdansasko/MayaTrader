//
//  LoginLoginViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol LoginViewInput: class {
    func setLoginData(loginModel: ExmoQRModel?)
    func login()
    func showAlert(title: String, message: String)
}

protocol LoginViewOutput {
    func viewIsReady()
    func loadUserInfo(loginModel: ExmoQRModel)
    func handleTouchOnScanQRButton()
    func closeViewController()
}
