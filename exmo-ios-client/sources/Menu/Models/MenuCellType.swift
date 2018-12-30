//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum MenuSectionType: Int {
    case Authorization
    case Purchase
    case Security
    case ContactWithUs
    case About

    var header: String? {
        switch self {
        case .Authorization: return "Authorization"
        case .Purchase: return "Purchases"
        case .Security: return "Security"
        case .ContactWithUs: return "Contact with us"
        case .About: return "About"
        }
    }

    static func getGuestUserCellsLayout() -> [MenuSectionType : [MenuCellType]] {
        return [
        .Authorization : [
            .Login,
        ],
        .Purchase : [
            .ProFeatures,
            .Advertisement,
        ],
        .Security : [
            .Passcode,
            .TouchId,
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
        .Authorization : [
            .Logout
        ],
        .Purchase : [
            .ProFeatures,
            .Advertisement,
        ],
        .Security : [
            .Passcode,
            .TouchId,
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

    case Passcode
    case TouchId

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
        case .Advertisement: return "Advertisement"

        case .TouchId: return "Touch ID"
        case .Passcode: return "Passcode"

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

        case .ProFeatures: return UIImage(named: "icMenuChat")
        case .Advertisement: return UIImage(named: "icMenuNews")

        case .TouchId: return UIImage(named: "icMenuChat")
        case .Passcode: return UIImage(named: "icMenuNews")

        case .Telegram: return UIImage(named: "icMenuChat")
        case .Facebook: return UIImage(named: "icMenuChat")

        case .RateUs: return UIImage(named: "icMenuAppversion")
        case .ShareApp: return UIImage(named: "icMenuAppversion")
        case .AppVersion: return UIImage(named: "icMenuAppversion")
        }
    }
}