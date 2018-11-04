//
//  MoreMenuRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class MenuRouter: MenuRouterInput {
    weak var output: MenuRouterOutput!
    
    func showViewController(sourceVC: UIViewController, touchedCellType: MenuCellType) {
        var nextViewController: UIViewController!
        switch touchedCellType {
        case .Login:
            let loginInit = LoginModuleInitializer()
            nextViewController = loginInit.viewController
            
            sourceVC.navigationController?.setToolbarHidden(true, animated: false)
            sourceVC.navigationController?.setNavigationBarHidden(true, animated: false)
            
            sourceVC.navigationController?.pushViewController(nextViewController, animated: true)
        case .Logout:
            output.userLogout()
        default:
            break
        }
    }
}
