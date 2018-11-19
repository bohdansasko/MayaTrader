//
// Created by Bogdan Sasko on 3/6/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//
import Foundation

typealias TextInVoidOutClosure = (String) -> Void
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

enum TableCellIdentifiers: String {
    case AlertTableViewCell
    case WatchlistTableMenuViewCell
}

enum WalletSegueIdentifiers: String {
    case ManageCurrencies
}

enum OrdersSegueIdentifiers: String {
    case CreateOrder
}

enum OrderActionType: String {
    case None
    case Buy = "Buy"
    case Sell = "Sell"
}
