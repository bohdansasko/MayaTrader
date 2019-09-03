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
                    print("path not found for \(file).plist")
                    throw Errors.fileNotFound
                }
                print("url is \(path)")
                return try Data(contentsOf: URL(fileURLWithPath: path))
            }
        }
    }
}
