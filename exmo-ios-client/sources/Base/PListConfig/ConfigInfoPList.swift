//
//  InfoPList.swift
//  exmo-ios-client
//

import Foundation

struct ConfigInfoPList: Codable {
    let appVersion: String
    let buildVersion: String
    let configuration: Configuration
    
    enum CodableKeys: String, CodingKey {
        case appVersion = "CFBundleShortVersionString"
        case buildVersion = "CFBundleVersion"
        case configuration
    }
    
    struct Configuration: Codable {
        let endpoint: String
        let admobAdsId: String
        
        enum ConfigCodableKeys: String, CodingKey {
            case endpoint
            case admobAdsId
        }
    }
    
}

// MARK: - ConfigInfoPList

extension ConfigInfoPList {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodableKeys.self)
        appVersion = try container.decode(String.self, forKey: CodableKeys.appVersion)
        buildVersion = try container.decode(String.self, forKey: CodableKeys.buildVersion)
        configuration = try container.decode(Configuration.self, forKey: CodableKeys.configuration)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodableKeys.self)
        try container.encode(appVersion, forKey: CodableKeys.buildVersion)
        try container.encode(buildVersion, forKey: CodableKeys.buildVersion)
        try container.encode(configuration, forKey: CodableKeys.configuration)
    }
    
}

// MARK: - Configuration

extension ConfigInfoPList.Configuration {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ConfigCodableKeys.self)
        endpoint = try container.decode(String.self, forKey: ConfigCodableKeys.endpoint)
        admobAdsId = try container.decode(String.self, forKey: ConfigCodableKeys.admobAdsId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ConfigCodableKeys.self)
        try container.encode(endpoint, forKey: ConfigCodableKeys.endpoint)
        try container.encode(admobAdsId, forKey: ConfigCodableKeys.admobAdsId)
    }
    
}
