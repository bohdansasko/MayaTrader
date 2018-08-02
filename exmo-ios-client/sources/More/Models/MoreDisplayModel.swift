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
            MenuItem(title: "News", iconNamed: "icMenuNews", segueIdentifier: MoreMenuSegueIdentifier.newsView.rawValue),
            MenuItem(title: "Chat", iconNamed: "icMenuChat", segueIdentifier: MoreMenuSegueIdentifier.chatView.rawValue),
            // MenuItem(title: "FAQ", iconNamed: "icMenuFAQ", segueIdentifier: MoreMenuSegueIdentifier.faqView.rawValue)
            MenuItem(title: "App version", iconNamed: "icMenuAppversion", segueIdentifier: "", rightViewOptions: MenuItem.RightViewOptions.Text, rightText: "v.1.0")
        ]

        if AppDelegate.session.isExmoAccountExists() {
            menuItems.append(MenuItem(title: "Logout", iconNamed: "icMenuLogout", rightViewOptions: MenuItem.RightViewOptions.Icon, action: {
                AppDelegate.session.logout()
            }))
        } else {
            menuItems.insert(MenuItem(title: "Login",  iconNamed: "icMenuLogin", segueIdentifier: MoreMenuSegueIdentifier.loginView.rawValue), at: 0)
        }
    }

    func isSegueItem(byRow: Int) -> Bool {
        return menuItems[byRow].isSegueItem()
    }

    func getCountMenuItems() -> Int {
        return menuItems.count
    }

    func getMenuItemTitle(byRow: Int) -> String {
        return menuItems[byRow].title
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
