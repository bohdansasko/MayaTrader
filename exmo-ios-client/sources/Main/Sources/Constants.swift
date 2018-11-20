//
// Created by Bogdan Sasko on 3/6/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//
import Foundation

typealias TextInVoidOutClosure = (String) -> Void
typealias VoidClosure = () -> Void
typealias IntInVoidOutClosure = (Int) -> Void

class Defaults {
    private init() { }
    
    static func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    static func setUserLoggedIn(_ state: Bool) {
        return UserDefaults.standard.set(state, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}

enum UserDefaultsKeys: String {
    case isLoggedIn
}

enum DefaultStringValues: String {
    case LastLoginedUID
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

enum OrderActionType: String {
    case None
    case Buy = "Buy"
    case Sell = "Sell"
}
