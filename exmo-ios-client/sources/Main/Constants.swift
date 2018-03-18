//
// Created by Bogdan Sasko on 3/6/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//
import Foundation

typealias VoidClosure = () -> Void

enum AppSettingsKeys: String {
    case LastLoginedUID
}

enum IDefaultValues: Int {
    case UserUID = -1
}

enum SDefaultValues: String {
    case ExmoIdentifier = "EXMO"
}

enum EntityNameKeys: String {
    case UserEntity
    case WalletEntity
}

enum UserEntityKeys: String {
    case exmoIdentifier
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
    case WalletSettingsCell
    case AlertTableViewCell
}

enum WalletSegueIdentifiers: String {
    case ManageCurrencies
}

enum AlertsSegueIdentifiers: String {
    case EditAlert
}