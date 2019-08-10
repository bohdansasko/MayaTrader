//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

struct CHMenuSectionModel {
    var section: CHMenuSectionType
    var cells  : [CHMenuCellType]
}

enum CHMenuSectionType: Int {
    case account
    case purchase
    case contactWithUs
    case about
}


// MARK: - CHMenuSectionType getters

extension CHMenuSectionType {

    var header: String? {
        switch self {
        case .account: return "Account"
        case .purchase: return "Purchases"
        case .contactWithUs: return "Contact with us"
        case .about: return "About"
        }
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
}

// MARK: - CHMenuCellType getters

extension CHMenuCellType {
    
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
