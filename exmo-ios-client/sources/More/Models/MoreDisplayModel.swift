//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class MoreDisplayModel {
    private var menuItems: [MenuItem]

    init() {
        menuItems = []
        self.update()
    }

    func update() {
        menuItems = [
            MenuItem(name: "Order history", segueIdentifier: MoreMenuSegueIdentifier.orderHistoryView.rawValue),
            MenuItem(name: "News", segueIdentifier: MoreMenuSegueIdentifier.newsView.rawValue),
            MenuItem(name: "Chat", segueIdentifier: MoreMenuSegueIdentifier.chatView.rawValue),
            MenuItem(name: "FAQ", segueIdentifier: MoreMenuSegueIdentifier.faqView.rawValue)
        ]

        if Session.sharedInstance.isExmoAccountExists() {
            menuItems.append(MenuItem(name: "Logout", action: { 
                Session.sharedInstance.logout()
            }))
        } else {
            menuItems.insert(MenuItem(name: "Login", segueIdentifier: "loginView"), at: 0)
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

    func doAction(itemIndex: Int) {
        menuItems[itemIndex].doAction()
    }
}
