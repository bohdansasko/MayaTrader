//
//  LoginLoginRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class LoginRouter: LoginRouterInput {
    func showQRScannerVC(segueBlock: QRScannerSegueBlock) {
        let scannerInit = QRScannerModuleInitializer()
        scannerInit.awakeFromNib()
        if let qrPresenter = scannerInit.qrScannerViewController.outputProtocol as? QRScannerModuleInput {
            qrPresenter.setLoginPresenter(presenter: segueBlock.outputPresenter)
        }
        
        segueBlock.sourceVC.present(scannerInit.qrScannerViewController, animated: true, completion: nil)
    }
    
    func closeViewController(_ vc: UIViewController) {
        vc.popViewController()
    }
}
