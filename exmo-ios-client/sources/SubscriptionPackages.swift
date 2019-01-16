//
// Created by Bogdan Sasko on 1/16/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol ISubscriptionPackage {
    var name: String {get}
    var isAdsPresent: Bool {get}
    var maxAlerts: Int {get}
    var maxPairsInWatchlist: Int {get}
}

struct BasicAdsSubscriptionPackage: ISubscriptionPackage {
    private(set) var name: String = "BasicAds"
    private(set) var isAdsPresent: Bool = true
    private(set) var maxAlerts: Int = 3
    private(set) var maxPairsInWatchlist: Int = 5
}

struct BasicNoAdsSubscriptionPackage: ISubscriptionPackage {
    private(set) var name: String = "BasicNoAds"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 3
    private(set) var maxPairsInWatchlist: Int = 5
}

struct LiteSubscriptionPackage: ISubscriptionPackage {
    private(set) var name: String = "Lite"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 10
    private(set) var maxPairsInWatchlist: Int = 10
}

struct ProSubscriptionPackage: ISubscriptionPackage {
    private(set) var name: String = "Pro"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 25
    private(set) var maxPairsInWatchlist: Int = 50
}
