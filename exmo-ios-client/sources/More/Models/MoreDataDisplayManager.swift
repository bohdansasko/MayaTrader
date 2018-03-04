//
//  MoreDataDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class MoreDataDisplayManager {
    private let menuItems = [
        MenuItem(name: "Login", segueIndentifier: "loginView"),
        MenuItem(name: "Order history", segueIndentifier: "orderHistoryView"),
        MenuItem(name: "News", segueIndentifier: "newsView"),
        MenuItem(name: "Chat", segueIndentifier: "chatView"),
        MenuItem(name: "FAQ", segueIndentifier: "faqView")
    ]
    
    func getCountMenuItems() -> Int {
        return menuItems.count
    }
    
    func getMenuItemName(byRow: Int) -> String {
        return menuItems[byRow].name
    }

    func getMenuItemSegueIdentifier(byRow: Int) -> String {
        return menuItems[byRow].segueIndentifier
    }
}
