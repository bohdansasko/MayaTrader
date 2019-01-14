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
        switch touchedCellType {
        case .login:
            let loginInit = LoginModuleInitializer()
            sourceVC.present(loginInit.viewController, animated: true)
        case .logout:
            output.userLogout()
        case .security:
            sourceVC.present(PasswordModuleConfigurator().navigationVC, animated: true)

        case .proFeatures:
            IAPService.shared.verifySubscription(.advertisements)
            let iapInitializer = IAPModuleInitializer()
            sourceVC.present(iapInitializer.viewController, animated: true)
        case .advertisement:
            IAPService.shared.purchase(product: .advertisements)

        case .restorePurchases:
            IAPService.shared.restorePurchases()
            
        case .telegram:
            if !openLinkOnSupportGroups(.telegramApp) {
                if !openLinkOnSupportGroups(.telegramWebsite) {
                    onFailOpenSocialGroups(.telegramWebsite)
                }
            }
        case .facebook:
            if !openLinkOnSupportGroups(.facebookApp) {
                if !openLinkOnSupportGroups(.facebookWebsite) {
                    onFailOpenSocialGroups(.facebookWebsite)
                }
            }

        case .rateUs:
            StoreReviewHelper.resetAppOpenedCount()
            StoreReviewHelper.requestReview()
        case .shareApp:
            if let link = NSURL(string: UserDefaultsKeys.appStoreLink.rawValue) {
                let objectsToShare = [link] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                sourceVC.present(activityVC, animated: true, completion: nil)
            }
        default:
            break
        }
    }
}

extension MenuRouter {
    func onFailOpenSocialGroups(_ link: LinkOnSupportGroups) {
        switch link {
        case .telegramApp, .telegramWebsite: print("can't open telegram.")
        case .facebookApp, .facebookWebsite: print("can't open facebook. install it, please")
        }
    }
    
    func openLinkOnSupportGroups(_ link: LinkOnSupportGroups) -> Bool {
        guard let socialURL = URL(string: link.rawValue) else {
            return false
        }
        
        if UIApplication.shared.canOpenURL(socialURL) {
            UIApplication.shared.open(socialURL)
            return true
        }
        return false
    }
}
