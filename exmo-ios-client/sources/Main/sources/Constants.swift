//
// Created by Bogdan Sasko on 3/6/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//
import Foundation

typealias TextInVoidOutClosure = (String) -> Void
typealias VoidClosure = () -> Void
typealias IntInVoidOutClosure = (Int) -> Void

enum LinkOnSupportGroups: String {
    case TelegramWebsite = "https://www.telegram.me/exmobile"
    case TelegramApp = "tg://resolve?domain=exmobile"
    case FacebookWebsite = "https://www.facebook.com/groups/exmobile"
    case FacebookApp = "fb://profile/508928876181291"
}

class Defaults {
    private init() { }
    
    static func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    static func setUserLoggedIn(_ state: Bool) {
        return UserDefaults.standard.set(state, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }

    static func getCountOpenedApp() -> Int {
        return UserDefaults.standard.integer(forKey: UserDefaultsKeys.APP_OPENED_COUNT.rawValue)
    }

    static func setCountAppOpened(_ count: Int) {
        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.APP_OPENED_COUNT.rawValue)
    }
    
    static func savePasscode(_ passcode: String) {
        UserDefaults.standard.set(passcode, forKey: UserDefaultsKeys.PASSCODE.rawValue)
    }

    static func resetPasscode() {
        savePasscode("")
    }

    static func getPasscode() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.PASSCODE.rawValue) ?? ""
    }
    
    static func isPasscodeActive() -> Bool {
        return !getPasscode().isEmpty
    }
}

enum UserDefaultsKeys: String {
    case isLoggedIn
    case APP_OPENED_COUNT
    case AppStoreLink = "https://www.telegram.me/exmo_official"
    case PASSCODE
}

enum KeychainDefaultKeys: String {
    case APNS_DEVICE_TOKEN
}

enum AdvertisingValues: String {
    case CONFIG_NAME = "GoogleService-Info"
    case CONFIG_EXT = "plist"
    case AD_UNIT_ID_FOR_BANNER_TEST
    case ADMOB_APP_ID
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
    case Buy = "buy"
    case Sell = "sell"

    func capsDescription() -> String {
        switch self {
        case .Buy: return "BUY"
        case .Sell: return "SELL"
        case .None: return "NONE"
        }
    }
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
}
