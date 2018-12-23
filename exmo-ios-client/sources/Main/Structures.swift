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
    var pairs: [String: TickerCurrencyModel] = [:]
    
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

class ExmoUserObject: Object, Mappable {
    @objc dynamic var uid = 0
    @objc dynamic var qr: ExmoQRObject?
    @objc dynamic var wallet: ExmoWalletObject?

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
        
        if let w = ExmoWalletObject(JSON: map.JSON) {
            wallet = w
        }
    }
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

class ExmoWalletObjectCurrencyObject: Object {
    @objc dynamic var code: String = ""
    @objc dynamic var balance: Double = 0
    @objc dynamic var orderId: Int = 0
    @objc dynamic var isFavourite = true
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

extension ExmoWalletObjectCurrencyObject: NSItemProviderWriting {
    public static var writableTypeIdentifiersForItemProvider: [String] {
        return [] // something here
    }
    
    public func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
        return nil // something here
    }
}


class ExmoQRObject: Object {
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
        return key.count > 0 && secret.count > 0 && exmoIdentifier == DefaultStringValues.ExmoId.rawValue
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

class ExmoWalletObjectTransactionHistoryObject: Object {
    @objc dynamic var amount: Double = 0
    @objc dynamic var date: Date?
    @objc dynamic var orderId: Int64 = 0
    @objc dynamic var pair: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var quantity: Double = 0
    @objc dynamic var tradeId: Int32 = 0
    @objc dynamic var type: String = ""
}

class ExmoWalletObject: Object, Mappable {
    @objc dynamic var id = 0
    var amountBTC: Double = 0
    var amountUSD: Double = 0
    
    var balances = List<ExmoWalletObjectCurrencyObject>()
    var favBalances: [ExmoWalletObjectCurrencyObject] = []
    var dislikedBalances: [ExmoWalletObjectCurrencyObject] = []
    
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
            let currency = ExmoWalletObjectCurrencyObject(code: key, balance: balance, countInOrders: countInOrders)
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

extension ExmoWalletObject {
    func refreshOnFavDislikeBalances() {
        balances.removeAll()
        
        for currencyIndex in (0..<favBalances.count) {
            favBalances[currencyIndex].orderId = currencyIndex
        }
        for currencyIndex in (0..<dislikedBalances.count) {
            dislikedBalances[currencyIndex].orderId = currencyIndex
        }
        
        balances.append(objectsIn: favBalances)
        balances.append(objectsIn: dislikedBalances)
    }
    
    func refresh() {
        favBalances = Array(balances.filter({ $0.isFavourite }))
        dislikedBalances = Array(balances.filter({ !$0.isFavourite }))

        favBalances = favBalances.sorted(by: { $0.orderId < $1.orderId })
        dislikedBalances = dislikedBalances.sorted(by: { $0.orderId < $1.orderId })
    }
    
    func getCountSections() -> Int {
        return favBalances.count != balances.count ? 2 : 1
    }
    
    func filter(_ closure: (ExmoWalletObjectCurrencyObject) -> Bool) -> [ExmoWalletObjectCurrencyObject] {
        return balances.filter(closure)
    }
    
    func countCurrencies() -> Int {
        return balances.count
    }
    
    func isAllCurrenciesFav() -> Bool {
        return favBalances.count > 0 && dislikedBalances.isEmpty
    }
    
    func swapByIndex(from fIndex: Int, to tIndex: Int) {
        balances.swapAt(fIndex, tIndex)
    }

    func swap(from sourceDestination: IndexPath, to targetDestination: IndexPath) {
        var fromContainer = sourceDestination.section == 0 && favBalances.count > 0 ? favBalances : dislikedBalances
        var toContainer = targetDestination.section == 0 && favBalances.count > 0 ? favBalances : dislikedBalances
        
        let sourceItem = fromContainer[sourceDestination.item]
        toContainer.insert(sourceItem, at: targetDestination.item)
        fromContainer.remove(at: sourceDestination.item)
        
        print("sourceDestination = \(sourceDestination)")
        print("targetDestination = \(targetDestination)")
    }

    func setFavourite(currencyCode: String, isFavourite: Bool) {
        let currency = balances.first(where: { $0.code == currencyCode })
        currency?.isFavourite = isFavourite
        refresh()
    }
    
    func getCurrency(index: Int) -> ExmoWalletObjectCurrencyObject {
        return balances[index]
    }
}

class SearchModel : Any {
    var name: String
    
    init(id: Int, name: String) {
        self.name = name
    }
    
    func getId() -> Int {
        return 0
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDisplayName() -> String {
        return Utils.getDisplayCurrencyPair(rawCurrencyPairName: self.name)
    }
}

class SearchCurrencyPairModel : SearchModel {
    var price: Double
    
    init(id: Int, name: String, price: Double) {
        self.price = price
        super.init(id: id, name: name)
    }
    
    func getPairPriceAsStr() -> String {
        return Utils.getFormatedPrice(value: self.price, maxFractDigits: 10)
    }
}
