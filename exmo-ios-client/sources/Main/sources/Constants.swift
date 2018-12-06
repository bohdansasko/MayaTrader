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
    case ExmoId = "EXMO"
}

struct FrequencyUpdateInSec {
    static let Watchlist = 10.0
    static let CurrenciesList = 10.0
    static let CreateOrder = 15.0
    static let SearchPair = 10.0
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
    case WatchlistTableMenuViewCell
}

enum OrderActionType: String {
    case None
    case Buy = "Buy"
    case Sell = "Sell"
}

struct ModelOrderViewCell {
    private var textContainer: [String:String]
    var isTextInputEnabled = true
    
    init(headerText: String, placeholderText: String, currencyName: String = "", rightText: String = "") {
        self.textContainer = [String:String]()
        self.textContainer["headerText"] = headerText
        self.textContainer["placeholderText"] = placeholderText
        self.textContainer["currencyName"] = currencyName
        self.textContainer["rightText"] = rightText
    }
    
    init(headerText: String = "") {
        self.init(headerText: headerText, placeholderText: "")
    }
    
    func getHeaderText() -> String {
        return textContainer["headerText"] ?? ""
    }
    
    func getPlaceholderText() -> String {
        return textContainer["placeholderText"] ?? ""
    }
    
    func getCurrencyName() -> String {
        return textContainer["currencyName"] ?? ""
    }
    
    func getRightText() -> String {
        return textContainer["rightText"] ?? ""
    }
}

enum AlertOperationType {
    case Add
    case Update
    case None
}