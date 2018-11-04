//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum MenuCellType {
    case None
    case Login
    case Logout
    case News
    case Chat
    case AppVersion

    
    var title: String? {
        switch self {
        case .None: return ""
        case .News: return "News"
        case .Chat: return "Chat"
        case .AppVersion: return "App version"
        case .Login: return "Login"
        case .Logout: return "Logout"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .None: return nil
        case .News: return UIImage(named: "icMenuNews")
        case .Chat: return UIImage(named: "icMenuChat")
        case .AppVersion: return UIImage(named: "icMenuAppversion")
        case .Login: return UIImage(named: "icMenuLogin")
        case .Logout: return UIImage(named: "icMenuLogout")
        }
    }
    
    static func getGuestUserCellsLayout() -> [IndexPath: MenuCellType] {
        return [
            IndexPath(row: 0, section: 0) : .Login,
            IndexPath(row: 1, section: 0) : .News,
            IndexPath(row: 2, section: 0) : .Chat,
            IndexPath(row: 3, section: 0) : .AppVersion
        ]
    }
    
    static func getLoginedUserCellsLayout() -> [IndexPath: MenuCellType] {
        return [
            IndexPath(row: 0, section: 0) : .News,
            IndexPath(row: 1, section: 0) : .Chat,
            IndexPath(row: 2, section: 0) : .AppVersion,
            IndexPath(row: 3, section: 0) : .Logout
        ]
    }
}