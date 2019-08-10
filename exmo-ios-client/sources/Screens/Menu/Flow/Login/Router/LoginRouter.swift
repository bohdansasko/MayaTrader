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
        let scannerModule = QRScannerModuleInitializer()
        if let qrPresenter = scannerModule.viewController.outputProtocol as? QRScannerModuleInput {
            qrPresenter.setLoginPresenter(presenter: segueBlock.outputPresenter)
        }
        
        segueBlock.sourceVC.present(UINavigationController(rootViewController: scannerModule.viewController), animated: false, completion: nil)
    }
    
    func closeViewController(_ vc: UIViewController) {
        vc.close()
    }
}
