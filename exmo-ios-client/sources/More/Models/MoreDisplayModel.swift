//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class MoreDisplayModel {
    private var menuItems: [MenuItem]

    init() {
        menuItems = []
    }

    func update() {
        menuItems = [
            MenuItem(name: "News", iconNamed: "icMenuNews", segueIdentifier: MoreMenuSegueIdentifier.newsView.rawValue),
            MenuItem(name: "Chat", iconNamed: "icMenuChat", segueIdentifier: MoreMenuSegueIdentifier.chatView.rawValue),
            // MenuItem(name: "FAQ", iconNamed: "icMenuFAQ", segueIdentifier: MoreMenuSegueIdentifier.faqView.rawValue)
            MenuItem(name: "App version", iconNamed: "icMenuAppversion", segueIdentifier: "")
        ]

        if Session.sharedInstance.isExmoAccountExists() {
            menuItems.append(MenuItem(name: MoreMenuSegueIdentifier.logout.rawValue, iconNamed: "icMenuLogout", action: {
                Session.sharedInstance.logout()
            }))
        } else {
            menuItems.insert(MenuItem(name: "Login",  iconNamed: "icMenuLogin", segueIdentifier: MoreMenuSegueIdentifier.loginView.rawValue), at: 0)
        }
    }

    func isSegueItem(byRow: Int) -> Bool {
        return menuItems[byRow].isSegueItem()
    }

    func getCountMenuItems() -> Int {
        return menuItems.count
    }

    func getMenuItemName(byRow: Int) -> String {
        return menuItems[byRow].name
    }

    func getMenuItemSegueIdentifier(byRow: Int) -> String {
        return menuItems[byRow].segueIdentifier
    }
    
    func getMenuItem(byRow: Int) -> MenuItem {
        return menuItems[byRow]
    }

    func doAction(itemIndex: Int) {
        menuItems[itemIndex].doAction()
    }
}
