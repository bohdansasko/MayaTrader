//
// Created by Bogdan Sasko on 1/16/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol ISubscriptionPackage {
    var isAdsPresent: Bool {get}
    var maxAlerts: Int {get}
    var maxPairsInWatchlist: Int {get}
}

struct BasicSubscriptionPackage: ISubscriptionPackage {
    private(set) var isAdsPresent: Bool = true
    private(set) var maxAlerts: Int = 3
    private(set) var maxPairsInWatchlist: Int = 5
}

struct LiteSubscriptionPackage: ISubscriptionPackage {
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 10
    private(set) var maxPairsInWatchlist: Int = 10
}

struct ProSubscriptionPackage: ISubscriptionPackage {
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 25
    private(set) var maxPairsInWatchlist: Int = 50
}