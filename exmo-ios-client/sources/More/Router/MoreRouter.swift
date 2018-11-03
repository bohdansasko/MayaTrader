//
//  MoreMoreRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class MoreRouter: MoreRouterInput {
    func onDidSelectMenuItem(viewController: UIViewController, segueIdentifier: String) {
        var nextViewController: UIViewController!

        switch segueIdentifier {
        case .loginView.rawValue:
            let loginInit = LoginModuleInitializer()
            loginInit.awakeFromNib()
            nextViewController = loginInit.loginViewController
        default:
            nextViewController = viewController.storyboard?.instantiateViewController(withIdentifier: segueIdentifier)
        }

        if segueIdentifier == MoreMenuSegueIdentifier.loginView.rawValue {
            viewController.navigationController?.setToolbarHidden(true, animated: false)
            viewController.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        viewController.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
