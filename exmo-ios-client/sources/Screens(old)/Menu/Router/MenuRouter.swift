////
////  MoreMenuRouter.swift
////  ExmoMobileClient
////
////  Created by TQ0oS on 27/02/2018.
////  Copyright © 2018 Roobik. All rights reserved.
////
//
//import UIKit
//
//class MenuRouter: MenuRouterInput {
//    weak var output: MenuRouterOutput!
//    
//    func showViewController(sourceVC: UIViewController, touchedCellType: CHMenuCellType) {
//        switch touchedCellType {
//        case .login:
//            let loginInit = LoginModuleInitializer()
//            sourceVC.present(loginInit.viewController, animated: true)
//        case .logout:
//            output.userLogout()
//        case .security:
//            sourceVC.present(PasswordModuleConfigurator().navigationVC, animated: true)
//
//        case .proFeatures:
//            IAPService.shared.verifySubscription(.noAds)
//            let iapInitializer = SubscriptionsModuleInitializer()
//            sourceVC.present(UINavigationController(rootViewController: iapInitializer.viewController), animated: true)
//        case .advertisement:
//            IAPService.shared.purchase(product: .noAds)
//
//        case .telegram:
//            if !openCHAppSupportGroups(.telegramApp) {
//                if !openCHAppSupportGroups(.telegramWebsite) {
//                    onFailOpenSocialGroups(.telegramWebsite)
//                }
//            }
//        case .facebook:
//            if !openCHAppSupportGroups(.facebookApp) {
//                if !openCHAppSupportGroups(.facebookWebsite) {
//                    onFailOpenSocialGroups(.facebookWebsite)
//                }
//            }
//
//        case .rateUs:
//            CHAppStoreReviewManager.resetAppOpenedCount()
//            CHAppStoreReviewManager.requestReview()
//        case .shareApp:
//            if let link = NSURL(string: UserDefaultsKeys.appStoreLink.rawValue) {
//                let objectsToShare = [link] as [Any]
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                sourceVC.present(activityVC, animated: true, completion: nil)
//            }
//        default:
//            break
//        }
//    }
//}
//
//extension MenuRouter {
//    
//}
