//
// Created by Bogdan Sasko on 3/6/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//
import Foundation

typealias TextInVoidOutClosure = (String) -> Void
typealias VoidClosure = () -> Void
typealias IntInVoidOutClosure = (Int) -> Void

enum LinkOnSupportGroups: String {
    case telegramWebsite = "https://www.telegram.me/exmobile"
    case telegramApp = "tg://resolve?domain=exmobile"
    case facebookWebsite = "https://www.facebook.com/groups/exmobile"
    case facebookApp = "fb://profile/508928876181291"
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
        return UserDefaults.standard.integer(forKey: UserDefaultsKeys.appOpenedCount.rawValue)
    }

    static func setCountAppOpened(_ count: Int) {
        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.appOpenedCount.rawValue)
    }
    
    static func savePasscode(_ passcode: String) {
        UserDefaults.standard.set(passcode, forKey: UserDefaultsKeys.passcode.rawValue)
    }

    static func resetPasscode() {
        savePasscode("")
    }

    static func getPasscode() -> String {
        return UserDefaults.standard.string(forKey: UserDefaultsKeys.passcode.rawValue) ?? ""
    }
    
    static func isPasscodeActive() -> Bool {
        return !getPasscode().isEmpty
    }
}

enum UserDefaultsKeys: String {
    case isLoggedIn
    case appOpenedCount
    case appStoreLink = "https://www.telegram.me/exmo_official"
    case passcode
    case exmoId = "EXMO"
    case iapAdvertisement
}

enum KeychainDefaultKeys: String {
    case apnsDeviceToken
}

enum AdvertisingValues: String {
    case googleConfigPlist = "GoogleService-Info"
    case googleConfigExt = "plist"
    case adUnitIDForBannerTest
    case admobAppID
}

struct FrequencyUpdateInSec {
    static let watchlist = 10.0
    static let currenciesList = 10.0
    static let createOrder = 15.0
    static let createAlert = 15.0
    static let searchPair = 10.0
}

enum OrderActionType: String {
    case none
    case buy = "buy"
    case sell = "sell"

    func capsDescription() -> String {
        switch self {
        case .buy: return "BUY"
        case .sell: return "SELL"
        case .none: return "NONE"
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
    case add
    case update
}

struct LimitObjects {
    let amount: Int
    let max: Int
}
