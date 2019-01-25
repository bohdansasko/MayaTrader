//
// Created by Bogdan Sasko on 1/16/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation


enum SubscriptionPackageType: Int {
    case freeWithAds = 0
    case freeNoAds = 1
    case lite = 2
    case pro = 3
}

protocol ISubscriptionPackage {
    var type: SubscriptionPackageType {get}
    var name: String {get}
    var isAdsPresent: Bool {get}
    var maxAlerts: Int {get}
    var maxPairsInWatchlist: Int {get}
}

struct SubscriptionPackage: ISubscriptionPackage, Codable {
    private(set) var type: SubscriptionPackageType = .freeWithAds
    private(set) var name: String = "FreeWithAds"
    private(set) var isAdsPresent: Bool = true
    private(set) var maxPairsInWatchlist: Int = 5
    private(set) var maxAlerts: Int = 3


    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case isAdsPresent = "is_ads_present"
        case maxPairsInWatchlist = "max_pairs"
        case maxAlerts = "max_alerts"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type.rawValue, forKey: CodingKeys.type)
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(isAdsPresent, forKey: CodingKeys.isAdsPresent)
        try container.encode(maxPairsInWatchlist, forKey: CodingKeys.maxPairsInWatchlist)
        try container.encode(maxAlerts, forKey: CodingKeys.maxAlerts)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let typeId = try container.decode(Int.self, forKey: CodingKeys.type)
        name = try container.decode(String.self, forKey: CodingKeys.name)
        isAdsPresent = try container.decode(Bool.self, forKey: CodingKeys.isAdsPresent)
        maxPairsInWatchlist = try container.decode(Int.self, forKey: CodingKeys.maxPairsInWatchlist)
        maxAlerts = try container.decode(Int.self, forKey: CodingKeys.maxAlerts)

        guard let subscriptionType = SubscriptionPackageType(rawValue: typeId) else {
            return
        }
        self.type = subscriptionType
    }
}


struct BasicAdsSubscriptionPackage: ISubscriptionPackage {
    private(set) var type: SubscriptionPackageType = .freeWithAds
    private(set) var name: String = "BasicAds"
    private(set) var isAdsPresent: Bool = true
    private(set) var maxAlerts: Int = 3
    private(set) var maxPairsInWatchlist: Int = 5
}

struct BasicNoAdsSubscriptionPackage: ISubscriptionPackage {
    private(set) var type: SubscriptionPackageType = .freeNoAds
    private(set) var name: String = "BasicNoAds"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 3
    private(set) var maxPairsInWatchlist: Int = 5
}

struct LiteSubscriptionPackage: ISubscriptionPackage {
    private(set) var type: SubscriptionPackageType = .lite
    private(set) var name: String = "Lite"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 10
    private(set) var maxPairsInWatchlist: Int = 10
}

struct ProSubscriptionPackage: ISubscriptionPackage {
    private(set) var type: SubscriptionPackageType = .pro
    private(set) var name: String = "Pro"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 25
    private(set) var maxPairsInWatchlist: Int = 50
}
