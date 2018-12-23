//
//  LoginLoginInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol LoginInteractorInput {
    func viewIsReady()
    func loadUserInfo(loginModel: ExmoQRObject)
}

protocol LoginInteractorOutput: class {
    func showAlert(title: String, message: String)
    func closeViewController()
}
