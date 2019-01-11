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

protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

class ExmoUserObject: Object {
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
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}

struct ExmoUser  {
    var uid = 0
    var qr: ExmoQR?
    var wallet: ExmoWallet?
}

extension ExmoUser: Persistable {
    init(managedObject: ExmoUserObject) {
        uid = managedObject.uid
        if let qr = managedObject.qr {
            self.qr = ExmoQR(managedObject: qr)
        }
        if let w = managedObject.wallet {
            wallet = ExmoWallet(managedObject: w)
        }
    }

    func managedObject() -> ExmoUserObject {
        let mo = ExmoUserObject()
        mo.uid = uid
        mo.qr = ExmoQRObject(exmoIdentifier: qr?.exmoIdentifier ?? "", key: qr?.key ?? "", secret: qr?.secret ?? "")
        mo.wallet = ExmoWalletObject()
        mo.wallet?.amountBTC = wallet?.amountBTC ?? 0
        mo.wallet?.amountUSD = wallet?.amountUSD ?? 0

        let moBalancesList = List<ExmoWalletCurrencyObject>()
        wallet?.balances.forEach({
            _currency in
            let currency = ExmoWalletCurrencyObject(code: _currency.code, balance: _currency.balance, countInOrders: _currency.countInOrders)
            currency.orderId = _currency.orderId
            currency.isFavourite = _currency.isFavourite
            moBalancesList.append(currency)
        })
        mo.wallet?.balances = moBalancesList
        return mo
    }
}

extension ExmoUser: Mappable {
    init?(map: Map) {
        self.init()

        if !map["uid"].isKeyPresent {
            return nil
        }
    }

    mutating func mapping(map: Map) {
        uid <- map["uid"]

        if let parsedWallet = ExmoWallet(JSON: map.JSON) {
            wallet = parsedWallet
        }
    }
}

class ExmoWalletCurrencyObject: Object {
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

class ExmoWalletCurrency: NSObject, Persistable {
    var code: String = ""
    var balance: Double = 0
    var orderId: Int = 0
    var isFavourite: Bool = true
    var countInOrders: Double = 0

    convenience init(code: String, balance: Double, orderId: Int, isFavourite: Bool, countInOrders: Double) {
        self.init()
        self.code = code
        self.balance = balance
        self.orderId = orderId
        self.isFavourite = isFavourite
        self.countInOrders = countInOrders
    }

    required convenience init(managedObject: ExmoWalletCurrencyObject) {
        self.init(code: managedObject.code, balance: managedObject.balance, orderId: managedObject.orderId, isFavourite: managedObject.isFavourite, countInOrders: managedObject.countInOrders)
    }

    func managedObject() -> ExmoWalletCurrencyObject {
        let obj = ExmoWalletCurrencyObject(code: code, balance: balance, countInOrders: countInOrders)
        obj.isFavourite = isFavourite
        obj.orderId = orderId
        return obj
    }
}

extension ExmoWalletCurrency: NSItemProviderWriting {
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

    convenience init(exmoIdentifier: String, key: String, secret: String) {
        self.init()

        self.exmoIdentifier = exmoIdentifier
        self.key = key
        self.secret = secret
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct ExmoQR {
    var id = 0
    var exmoIdentifier: String = ""
    var key: String = ""
    var secret: String = ""

    init(qrParsedStr: String) {
        parseQRString(qrString: qrParsedStr)
    }

    init(exmoIdentifier: String, key: String, secret: String) {
        self.exmoIdentifier = exmoIdentifier
        self.key = key
        self.secret = secret
    }

    func isValidate() -> Bool {
        return true
//        return key.count > 0 && secret.count > 0 && exmoIdentifier == DefaultStringValues.exmoId.rawValue
    }

    private mutating func parseQRString(qrString: String) {
        let componentsArr = qrString.components(separatedBy: "|")
        if componentsArr.count > 2 {
            exmoIdentifier = componentsArr[0]
            key = componentsArr[1]
            secret = componentsArr[2]
        }
    }
}

extension ExmoQR: Persistable {
    init(managedObject: ExmoQRObject) {
        exmoIdentifier = managedObject.exmoIdentifier
        key = managedObject.key
        secret = managedObject.secret
    }
    
    func managedObject() -> ExmoQRObject {
        return ExmoQRObject(exmoIdentifier: exmoIdentifier, key: key, secret: secret)
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

class ExmoWalletObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var amountBTC: Double = 0
    @objc dynamic var amountUSD: Double = 0
    
    var balances = List<ExmoWalletCurrencyObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

struct ExmoWallet {
    var id: Int = 0
    var amountBTC: Double = 0
    var amountUSD: Double = 0

    var balances: [ExmoWalletCurrency] = []
    var favBalances: [ExmoWalletCurrency] = []
    var dislikedBalances: [ExmoWalletCurrency] = []
}

extension ExmoWallet: Mappable {
    init?(map: Map) {
        // do nothing
    }

    mutating func mapping(map: Map) {
        var balances: [String: String] = [:]
        var reserved: [String: String] = [:]

        balances <- map["balances"]
        reserved <- map["reserved"]

        balances.forEach { (key: String, value: String) in
            guard let balance = Double(value),
                  let reservedValue = reserved[key],
                  let countInOrders = Double(reservedValue) else { return }
            let currency = ExmoWalletCurrency(code: key, balance: balance, orderId: 0, isFavourite: true, countInOrders: countInOrders)
            self.balances.append(currency)
        }
    }
}

extension ExmoWallet: Persistable {
    init(managedObject: ExmoWalletObject) {
        id = managedObject.id
        amountBTC = managedObject.amountBTC
        amountUSD = managedObject.amountUSD

        var b = [ExmoWalletCurrency]()
        managedObject.balances.forEach({
            moCurrency in
            let currency = ExmoWalletCurrency(code: moCurrency.code, balance: moCurrency.balance, orderId: moCurrency.orderId, isFavourite: moCurrency.isFavourite, countInOrders: moCurrency.countInOrders)
            b.append(currency)
        })
        balances = b
    }

    func managedObject() -> ExmoWalletObject {
        let wallet = ExmoWalletObject()
        wallet.amountBTC = amountBTC
        wallet.amountUSD = amountUSD

        let moBalances: List<ExmoWalletCurrencyObject> = List<ExmoWalletCurrencyObject>()
        balances.forEach({
            currency in
            let mo = ExmoWalletCurrencyObject(code: currency.code, balance: currency.balance, countInOrders: currency.countInOrders)
            mo.orderId = currency.orderId
            mo.isFavourite = currency.isFavourite
            moBalances.append(mo)
        })
        wallet.balances = moBalances
        return wallet
    }
}

extension ExmoWallet {
    mutating func refreshOnFavDislikeBalances() {
        balances.removeAll()
        
        for currencyIndex in (0..<favBalances.count) {
            favBalances[currencyIndex].orderId = currencyIndex
        }
        for currencyIndex in (0..<dislikedBalances.count) {
            dislikedBalances[currencyIndex].orderId = currencyIndex
        }
        
        balances.append(contentsOf: favBalances)
        balances.append(contentsOf: dislikedBalances)
    }

    mutating func refresh() {
        favBalances = Array(balances.filter({ $0.isFavourite }))
        dislikedBalances = Array(balances.filter({ !$0.isFavourite }))

        favBalances = favBalances.sorted(by: { $0.orderId < $1.orderId })
        dislikedBalances = dislikedBalances.sorted(by: { $0.orderId < $1.orderId })
    }
    
    func getCountSections() -> Int {
        return favBalances.count != balances.count ? 2 : 1
    }

    func filter(_ closure: (ExmoWalletCurrency) -> Bool) -> [ExmoWalletCurrency] {
        return balances.filter(closure)
    }

    func countCurrencies() -> Int {
        return balances.count
    }
    
    func isAllCurrenciesFav() -> Bool {
        return favBalances.count > 0 && dislikedBalances.isEmpty
    }

    mutating func swapByIndex(from fIndex: Int, to tIndex: Int) {
        balances.swapAt(fIndex, tIndex)
    }

    mutating func swap(from sourceDestination: IndexPath, to targetDestination: IndexPath) {
        var fromContainer = sourceDestination.section == 0 && favBalances.count > 0 ? favBalances : dislikedBalances
        var toContainer = targetDestination.section == 0 && favBalances.count > 0 ? favBalances : dislikedBalances
        
        let sourceItem = fromContainer[sourceDestination.item]
        toContainer.insert(sourceItem, at: targetDestination.item)
        fromContainer.remove(at: sourceDestination.item)
        
        print("sourceDestination = \(sourceDestination)")
        print("targetDestination = \(targetDestination)")
    }

    mutating func setFavourite(currencyCode: String, isFavourite: Bool) {
        guard let favIndex = balances.firstIndex(where: { $0.code == currencyCode }) else {
            print("couldn't found index")
            return
        }
        balances[favIndex].isFavourite = isFavourite
        refresh()
    }
    
    func getCurrency(index: Int) -> ExmoWalletCurrency {
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
