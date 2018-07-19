//
// Created by Bogdan Sasko on 3/6/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//
import Foundation

typealias VoidClosure = () -> Void
typealias IntInVoidOutClosure = (Int) -> Void

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

enum MoreMenuSegueIdentifier: String {
    case loginView
    case Logout
    case newsView
    case chatView
    case faqView
}

enum TableCellIdentifiers: String {
    case MoreMenuItem
    case WalletTableViewCell
    case WalletSettingsCell
    case AlertTableViewCell
    case OrderTableViewCell
    case WatchlistMenuViewCell
}

enum WalletSegueIdentifiers: String {
    case ManageCurrencies
}

enum AlertsSegueIdentifiers: String {
    case EditAlert
}

enum OrdersSegueIdentifiers: String {
    case CreateOrder
}

enum OrderType {
    case None
    case Buy
    case Sell
}
