//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum MenuSectionType: Int {
    case account
    case purchase
    case contactWithUs
    case about

    var header: String? {
        switch self {
        case .account: return "Account"
        case .purchase: return "Purchases"
        case .contactWithUs: return "Contact with us"
        case .about: return "About"
        }
    }

    static func getGuestUserCellsLayout() -> [MenuSectionType : [MenuCellType]] {
        return [
        .account : [
            .login,
            .security
        ],
        .purchase : [
            .proFeatures,
            .advertisement,
            .restorePurchases
        ],
        .contactWithUs : [
            .facebook,
            .telegram,
        ],
        .about : [
            .rateUs,
            .shareApp,
            .appVersion
        ]]
    }

    static func getLoginedUserCellsLayout() -> [MenuSectionType : [MenuCellType]] {
        return [
        .account : [
            .logout,
            .security
        ],
        .purchase : [
            .proFeatures,
            .advertisement,
            .restorePurchases
        ],
        .contactWithUs : [
            .facebook,
            .telegram,
        ],
        .about : [
            .rateUs,
            .shareApp,
            .appVersion
        ]]
    }
}

enum MenuCellType {
    case none

    case login
    case logout

    case proFeatures
    case advertisement
    case restorePurchases

    case security

    case telegram
    case facebook

    case rateUs
    case shareApp
    case appVersion

    
    var title: String? {
        switch self {
        case .none: return ""

        case .login: return "Login"
        case .logout: return "Logout"

        case .proFeatures: return "Pro features"
        case .advertisement: return "Remove Ads"
        case .restorePurchases: return "Restore Purchases"
            
        case .security: return "Security"

        case .telegram: return "Telegram"
        case .facebook: return "Facebook"

        case .rateUs: return "Rate us"
        case .shareApp: return "Share app"
        case .appVersion: return "App version"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .none: return nil

        case .login: return UIImage(named: "icMenuLogin")
        case .logout: return UIImage(named: "icMenuLogout")

        case .proFeatures: return UIImage(named: "icProFeatures")
        case .advertisement: return UIImage(named: "icAds")
        case .restorePurchases: return UIImage(named: "icProFeatures")
            
        case .security: return UIImage(named: "icTouchId")

        case .telegram: return UIImage(named: "icTelegram")
        case .facebook: return UIImage(named: "icFacebook")

        case .rateUs: return UIImage(named: "icStar")
        case .shareApp: return UIImage(named: "icShare")
        case .appVersion: return UIImage(named: "icMenuAppversion")
        }
    }
}
