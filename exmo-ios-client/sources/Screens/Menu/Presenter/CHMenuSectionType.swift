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
    
    var header: String {
        switch self {
        case .account:
            return "SCREEN_MENU_SECTION_ACCOUNT".localized
        case .purchase:
            return "SCREEN_MENU_SECTION_PURCHASES".localized
        case .contactWithUs:
            return "SCREEN_MENU_SECTION_CONTACT".localized
        case .about:
            return "SCREEN_MENU_SECTION_ABOUT".localized
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
        case .login :
            return "SCREEN_MENU_ITEM_LOGIN".localized
        case .logout:
            return "SCREEN_MENU_ITEM_LOGOUT".localized

        case .proFeatures  :
            return "SCREEN_MENU_ITEM_FEATURES".localized
        case .advertisement:
            return "SCREEN_MENU_ITEM_REMOVE_ADS".localized

        case .security:
            return "SCREEN_MENU_ITEM_SECURITY".localized

        case .telegram:
            return "SCREEN_MENU_ITEM_TELEGRAM".localized
        case .facebook:
            return "SCREEN_MENU_ITEM_FACEBOOK".localized

        case .rateUs:
            return "SCREEN_MENU_ITEM_RATE_US".localized
        case .shareApp:
            return "SCREEN_MENU_ITEM_SHARE_APP".localized
        case .appVersion:
            return "SCREEN_MENU_ITEM_APP_VERSION".localized
        }
    }
    
    var icon: UIImage {
        switch self {
        case .login : return #imageLiteral(resourceName: "icMenuLogin")
        case .logout: return #imageLiteral(resourceName: "icMenuLogout")

        case .proFeatures  : return #imageLiteral(resourceName: "icProFeatures")
        case .advertisement: return #imageLiteral(resourceName: "icAds")
            
        case .security: return #imageLiteral(resourceName: "icTouchId")
            
        case .telegram: return #imageLiteral(resourceName: "icTelegram")
        case .facebook: return #imageLiteral(resourceName: "icFacebook")

        case .rateUs    : return #imageLiteral(resourceName: "icStar")
        case .shareApp  : return #imageLiteral(resourceName: "icShare")
        case .appVersion: return #imageLiteral(resourceName: "icMenuAppversion")
        }
    }
    
}
