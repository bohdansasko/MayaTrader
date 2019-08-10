//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum CHMenuSectionType: Int {
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

    static func getGuestUserCellsLayout(isAdsPresent: Bool) -> [CHMenuSectionType : [CHMenuCellType]] {
        let purchaseGroup: [CHMenuCellType] = isAdsPresent
                ? [ .proFeatures, .advertisement ]
                : [ .proFeatures ]

        return [
            .account : [
                .login,
                .security
            ],
            .purchase : purchaseGroup,
            .contactWithUs : [
                .facebook,
                .telegram,
            ],
            .about : [
                .rateUs,
                .shareApp,
                .appVersion
            ]
        ]
    }

    static func getLoginedUserCellsLayout(isAdsPresent: Bool) -> [CHMenuSectionType : [CHMenuCellType]] {
        let purchaseGroup: [CHMenuCellType] = isAdsPresent
                ? [ .proFeatures, .advertisement ]
                : [ .proFeatures ]

        return [
            .account : [
                .logout,
                .security
            ],
            .purchase : purchaseGroup,
            .contactWithUs : [
                .facebook,
                .telegram,
            ],
            .about : [
                .rateUs,
                .shareApp,
                .appVersion
            ]
        ]
    }
}

enum CHMenuCellType {
    case login
    case logout

    case proFeatures
    case advertisement

    case security

    case telegram
    case facebook

    case rateUs
    case shareApp
    case appVersion

    
    var title: String? {
        switch self {
        case .login : return "Login"
        case .logout: return "Logout"

        case .proFeatures  : return "Pro features"
        case .advertisement: return "Remove Ads"

        case .security: return "Security"

        case .telegram: return "Telegram"
        case .facebook: return "Facebook"

        case .rateUs    : return "Rate us"
        case .shareApp  : return "Share App"
        case .appVersion: return "App version"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .login: return UIImage(named: "icMenuLogin")
        case .logout: return UIImage(named: "icMenuLogout")

        case .proFeatures: return UIImage(named: "icProFeatures")
        case .advertisement: return UIImage(named: "icAds")

        case .security: return UIImage(named: "icTouchId")

        case .telegram: return UIImage(named: "icTelegram")
        case .facebook: return UIImage(named: "icFacebook")

        case .rateUs: return UIImage(named: "icStar")
        case .shareApp: return UIImage(named: "icShare")
        case .appVersion: return UIImage(named: "icMenuAppversion")
        }
    }
}
