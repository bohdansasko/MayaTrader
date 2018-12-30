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
        case .Login:
            let loginInit = LoginModuleInitializer()
            sourceVC.present(loginInit.viewController, animated: true)
        case .Logout:
            output.userLogout()

        case .ProFeatures: break;
        case .Advertisement: break;

        case .Passcode: break;
        case .TouchId: break;

        case .Telegram:
            if !openLinkOnSupportGroups(.TelegramApp) {
                if !openLinkOnSupportGroups(.TelegramWebsite) {
                    onFailOpenSocialGroups(.TelegramWebsite)
                }
            }
        case .Facebook:
            if !openLinkOnSupportGroups(.Facebook) {
                onFailOpenSocialGroups(.TelegramApp)
            }

        case .RateUs:
            StoreReviewHelper.resetAppOpenedCount()
            StoreReviewHelper.requestReview()
        case .ShareApp: break;
        case .AppVersion: break;

        default:
            break
        }
    }

    private func onFailOpenSocialGroups(_ link: LinkOnSupportGroups) {
        switch link {
        case .TelegramApp, .TelegramWebsite: print("can't open telegram.")
        case .Facebook: print("can't open facebook. install it, please")
        }
    }

    private func openLinkOnSupportGroups(_ link: LinkOnSupportGroups) -> Bool {
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
