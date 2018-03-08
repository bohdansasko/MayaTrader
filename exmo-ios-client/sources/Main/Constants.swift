//
// Created by Bogdan Sasko on 3/6/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//
import Foundation

typealias VoidClosure = () -> Void

enum AppSettingsKeys: String {
    case LastLoginedUID
}

enum UserEntity: String {
    case uid
    case key
    case secret
    case balances
}

extension Notification.Name {
    static let UserLoggedIn = Notification.Name("UserLoggedIn")
    static let UserLogout = Notification.Name("UserLogout")
}

enum MoreMenuSegueIdentifier: String {
    case orderHistoryView
    case newsView
    case chatView
    case faqView
}

enum TableCellIdentifiers: String {
    case MoreMenuItem
    case WalletTableViewCell
}
