//
//  LoginLoginRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

final class LoginRouter: LoginRouterInput {
    func showQRScannerVC(segueBlock: QRScannerSegueBlock) {
        // do nothing
    }
    
    func closeViewController(_ vc: UIViewController) {
        vc.close()
    }
}
