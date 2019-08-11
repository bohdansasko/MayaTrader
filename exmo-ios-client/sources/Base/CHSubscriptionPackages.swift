//
// Created by Bogdan Sasko on 1/16/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

enum CHSubscriptionPackageType: Int {
    case freeWithAds = 0
    case freeNoAds = 1
    case lite = 2
    case pro = 3
}

protocol CHSubscriptionPackageProtocol {
    var type: CHSubscriptionPackageType {get}
    var name: String {get}
    var isAdsPresent: Bool {get}
    var maxAlerts: Int {get}
    var maxPairsInWatchlist: Int {get}
}

struct CHSubscriptionPackage: CHSubscriptionPackageProtocol, Codable {
    private(set) var type: CHSubscriptionPackageType = .freeWithAds
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

        guard let subscriptionType = CHSubscriptionPackageType(rawValue: typeId) else {
            return
        }
        self.type = subscriptionType
    }
}


struct CHBasicAdsSubscriptionPackage: CHSubscriptionPackageProtocol {
    private(set) var type: CHSubscriptionPackageType = .freeWithAds
    private(set) var name: String = "BasicAds"
    private(set) var isAdsPresent: Bool = true
    private(set) var maxAlerts: Int = 3
    private(set) var maxPairsInWatchlist: Int = 5
}

struct CHBasicNoAdsSubscriptionPackage: CHSubscriptionPackageProtocol {
    private(set) var type: CHSubscriptionPackageType = .freeNoAds
    private(set) var name: String = "BasicNoAds"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 3
    private(set) var maxPairsInWatchlist: Int = 5
}

struct CHLiteSubscriptionPackage: CHSubscriptionPackageProtocol {
    private(set) var type: CHSubscriptionPackageType = .lite
    private(set) var name: String = "Lite"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 10
    private(set) var maxPairsInWatchlist: Int = 10
}

struct CHProSubscriptionPackage: CHSubscriptionPackageProtocol {
    private(set) var type: CHSubscriptionPackageType = .pro
    private(set) var name: String = "Pro"
    private(set) var isAdsPresent: Bool = false
    private(set) var maxAlerts: Int = 25
    private(set) var maxPairsInWatchlist: Int = 50
}
