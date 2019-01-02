//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum MenuSectionType: Int {
    case Account
    case Purchase
    case ContactWithUs
    case About

    var header: String? {
        switch self {
        case .Account: return "Account"
        case .Purchase: return "Purchases"
        case .ContactWithUs: return "Contact with us"
        case .About: return "About"
        }
    }

    static func getGuestUserCellsLayout() -> [MenuSectionType : [MenuCellType]] {
        return [
        .Account : [
            .Login,
            .Security
        ],
        .Purchase : [
            .ProFeatures,
            .Advertisement,
        ],
        .ContactWithUs : [
            .Facebook,
            .Telegram,
        ],
        .About : [
            .RateUs,
            .ShareApp,
            .AppVersion
        ]]
    }

    static func getLoginedUserCellsLayout() -> [MenuSectionType : [MenuCellType]] {
        return [
        .Account : [
            .Logout,
            .Security
        ],
        .Purchase : [
            .ProFeatures,
            .Advertisement,
        ],
        .ContactWithUs : [
            .Facebook,
            .Telegram,
        ],
        .About : [
            .RateUs,
            .ShareApp,
            .AppVersion
        ]]
    }
}

enum MenuCellType {
    case None

    case Login
    case Logout

    case ProFeatures
    case Advertisement

    case Security

    case Telegram
    case Facebook

    case RateUs
    case ShareApp
    case AppVersion

    
    var title: String? {
        switch self {
        case .None: return ""

        case .Login: return "Login"
        case .Logout: return "Logout"

        case .ProFeatures: return "Pro features"
        case .Advertisement: return "Remove Ads"

        case .Security: return "Security"

        case .Telegram: return "Telegram"
        case .Facebook: return "Facebook"

        case .RateUs: return "Rate us"
        case .ShareApp: return "Share app"
        case .AppVersion: return "App version"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .None: return nil

        case .Login: return UIImage(named: "icMenuLogin")
        case .Logout: return UIImage(named: "icMenuLogout")

        case .ProFeatures: return UIImage(named: "icProFeatures")
        case .Advertisement: return UIImage(named: "icAds")

        case .Security: return UIImage(named: "icTouchId")

        case .Telegram: return UIImage(named: "icTelegram")
        case .Facebook: return UIImage(named: "icFacebook")

        case .RateUs: return UIImage(named: "icStar")
        case .ShareApp: return UIImage(named: "icShare")
        case .AppVersion: return UIImage(named: "icMenuAppversion")
        }
    }
}
