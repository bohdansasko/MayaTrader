//
//  Structures.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

import SwiftyJSON
import ObjectMapper
import RealmSwift
import Realm

class QRScannerSegueBlock: SegueBlock {
    var sourceVC: UIViewController
    var outputPresenter: LoginModuleOutput

    init(sourceVC: UIViewController, outputPresenter: LoginModuleOutput) {
        self.sourceVC = sourceVC
        self.outputPresenter = outputPresenter
    }
}

struct Ticker: Mappable {
    var pairs: [String: TickerCurrencyModel?] = [:]
    
    init?(map: Map) {
        pairs = [:]
        for (key, value) in map.JSON {
            guard let json = value as? JSON else { continue }
            if var model = TickerCurrencyModel(JSONString: json.description) {
                model.code = key
                pairs[key] = model
            }
        }
    }
    
    mutating func mapping(map: Map) {
        // do nothing
    }
}

class ExmoUser: Object, Mappable {
    @objc dynamic var uid = 0
    @objc dynamic var qr: ExmoQRModel?
    @objc dynamic var wallet: ExmoWallet?

    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    convenience required init?(map: Map) {
        self.init()
        
        if !map["uid"].isKeyPresent {
            return nil
        }
    }

    func mapping(map: Map) {
        uid <- map["uid"]
        
        if let w = ExmoWallet(JSON: map.JSON) {
            wallet = w
        }
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

class ExmoWalletCurrencyModel: Object {
    @objc dynamic var code: String = ""
    @objc dynamic var balance: Double = 0
    @objc dynamic var orderId: Int = 0
    @objc dynamic var isFavourite = false
    @objc dynamic var countInOrders: Double = 0
    
    required convenience init(code: String, balance: Double, countInOrders: Double) {
        self.init()

        self.code = code
        self.balance = balance
        self.countInOrders = countInOrders
    }
    
    override static func primaryKey() -> String? {
        return "code"
    }
}

class ExmoQRModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var exmoIdentifier: String = ""
    @objc dynamic var key: String = ""
    @objc dynamic var secret: String = ""

    convenience init(qrParsedStr: String) {
        self.init()
        parseQRString(qrString: qrParsedStr)
    }

    convenience init(exmoIdentifier: String, key: String, secret: String) {
        self.init()

        self.exmoIdentifier = exmoIdentifier
        self.key = key
        self.secret = secret
    }

    func isValidate() -> Bool {
        return key.count > 0 && secret.count > 0 && exmoIdentifier == "EXMO"
    }

    private func parseQRString(qrString: String) {
        let componentsArr = qrString.components(separatedBy: "|")
        if componentsArr.count > 2 {
            exmoIdentifier = componentsArr[0]
            key = componentsArr[1]
            secret = componentsArr[2]
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ExmoWalletTransactionHistory: Object {
    @objc dynamic var amount: Double = 0
    @objc dynamic var date: Date?
    @objc dynamic var orderId: Int64 = 0
    @objc dynamic var pair: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var quantity: Double = 0
    @objc dynamic var tradeId: Int32 = 0
    @objc dynamic var type: String = ""
}

class ExmoWallet: Object, Mappable {
    @objc dynamic var id = 0
    @objc dynamic var amountBTC: Double = 0
    @objc dynamic var amountUSD: Double = 0
    
    var balances = List<ExmoWalletCurrencyModel>()
    
    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        var balances: [String: String] = [:]
        var reserved: [String: String] = [:]
        
        balances <- map["balances"]
        reserved <- map["reserved"]

        balances.forEach { (key: String, value: String) in
            guard let balance = Double(value),
                let reservedValue = reserved[key],
                  let countInOrders = Double(reservedValue) else { return }
            let currency = ExmoWalletCurrencyModel(code: key, balance: balance, countInOrders: countInOrders)
            self.balances.append(currency)
        }
    }

    func isDataExists() -> Bool {
        return !balances.isEmpty
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
