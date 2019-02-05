//
//  PListFile.swift
//  exmo-ios-client
//

import Foundation

class PListFile<Value: Codable> {
    let model: Value
    init(_ file: PListFile.Source = .infoPlist(Bundle.main)) throws {
        let fileData = try file.data()
        model = try JSONDecoder().decode(Value.self, from: fileData)
    }
}

extension PListFile {
    enum Errors: Error {
        case fileNotFound
    }
    
    enum Source {
        case infoPlist(_ bundle : Bundle)
        case plist(_: String, _ bundle: Bundle)
        
        func data() throws -> Data {
            switch self {
            case .infoPlist(let bundle):
                guard let infoDict = bundle.infoDictionary else {
                    throw Errors.fileNotFound
                }
                return try JSONSerialization.data(withJSONObject: infoDict)
            case .plist(let file, let bundle):
                guard let path = bundle.path(forResource: file, ofType: "plist") else {
                    throw Errors.fileNotFound
                }
                return try Data(contentsOf: URL(fileURLWithPath: path))
            }
        }
    }
}

func f() {
    do {
        let f = try PListFile<EXMobilePList>(.plist("Development", Bundle.main))
        print("bundleVersion is \(f.model.bundleVersion)")
    } catch (let error) {
        print("plisterror " + error.localizedDescription)
    }

    do {
        let f = try PListFile<GoogleServicePList>(.plist("GoogleService-Info", Bundle.main))
        print("bannerAdsTestId is \(f.model.bannerAdsTestId)")
    } catch (let error) {
        print("plisterror " + error.localizedDescription)
    }
}
