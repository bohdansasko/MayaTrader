//
//  PListModels.swift
//  exmo-ios-client
//

import Foundation

struct EXMobilePList: Codable {
    let bundleVersion: String
    enum CodableKeys: String, CodingKey {
        case bundleVersion = "CFBundleVersion"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodableKeys.self)
        bundleVersion = try container.decode(String.self, forKey: CodableKeys.bundleVersion)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodableKeys.self)
        try container.encode(bundleVersion, forKey: CodableKeys.bundleVersion)
    }
}

struct GoogleServicePList: Codable {
    let bannerAdsTestId: String
    
    enum CodableKeys: String, CodingKey {
        case bannerAdsTestId = "AD_UNIT_ID_FOR_BANNER_TEST"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodableKeys.self)
        bannerAdsTestId = try container.decode(String.self, forKey: CodableKeys.bannerAdsTestId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodableKeys.self)
        try container.encode(bannerAdsTestId, forKey: CodableKeys.bannerAdsTestId)
    }
}
