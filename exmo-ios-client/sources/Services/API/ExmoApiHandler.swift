//
//  AppDelegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/20/18.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import ObjectMapper
import CommonCrypto

public class ExmoApiHandler {
    static let shared = ExmoApiHandler()
    
    fileprivate struct ConnectionConfig {
        static let API_URL = "https://api.exmo.com/v1/"
        static var API_KEY = "your_key"
        static var API_SECRET = "your_secret"
        static var NONCE = "Nonce"
    }

    private var nonce: Int {
        get {
            let value = UserDefaults.standard.integer(forKey: ConnectionConfig.NONCE)
            return (value == 0) ? calculateInitialNonce(): value
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ConnectionConfig.NONCE)
        }
    }

    private init() {
        // do nothing
    }
}

//
// @MARK: common methods
//
extension ExmoApiHandler {
    fileprivate func getResponseFromServerForPost(postDictionary: [String: Any], method: String) -> Data? {
        var post: String = ""
        var index: Int = 0
        for (key, value) in postDictionary {
            if (index == 0) {
                post = "\(key)=\(value)"
            } else {
                post = "\(post)&\(key)=\(value)"
            }
            index += 1
        }
        post = "\(post)&nonce=\(nonce)"
        nonce += 1
        print(post)
        
        let signedPost = hmacForKeyAndData(key: ConnectionConfig.API_SECRET, data: post)
        let strUrlValue = ConnectionConfig.API_URL as String + method
        let request = NSMutableURLRequest(url: URL(string: strUrlValue)!)
        
        request.httpMethod = "POST"
        request.setValue(ConnectionConfig.API_KEY, forHTTPHeaderField: "Key")
        request.setValue(signedPost, forHTTPHeaderField: "Sign")
        
        let requestBodyData = post.data(using: .utf8)
        request.httpBody = requestBodyData
        
        // var error: NSError?
        let theResponse: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        let responseData = try! NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: theResponse) as Data?
//        if (error != nil){
//            return nil
//        }
        
        return responseData
    }
    
    private func calculateInitialNonce()-> Int {
        let dataFormat = DateFormatter()
        dataFormat.dateFormat = "yyyy-MM-dd HH:mm:ss xxxx"
        let timeStamp = Date().timeIntervalSince(dataFormat.date(from: "2012-04-18 00:00:03 +0600")!)
        let currentNonce = Int(timeStamp)
        return currentNonce
    }
    
    
    private func hmacForKeyAndData(key: String, data: String)-> String {
        let cKey =  key.cString(using: String.Encoding.ascii)
        let cData = data.cString(using: String.Encoding.ascii)
        let _ = [CUnsignedChar](repeatElement(0, count: Int(CC_SHA512_DIGEST_LENGTH)))
        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        print("CCHmac")
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), cKey, Int(key.count), cData, Int(data.count), result)
        let hashString =  NSMutableString(capacity: Int(CC_SHA512_DIGEST_LENGTH))
        for i in 0..<digestLen {
            hashString.appendFormat("%02x", result[i])
        }
        return hashString as String
    }
}

//
// @MARK: service methods
//
extension ExmoApiHandler {
    func setAuthorizationData(apiKey: String, secretKey: String) {
        ConnectionConfig.API_KEY = apiKey
        ConnectionConfig.API_SECRET = secretKey
    }
    
    func loadUserInfo() -> Data? {
        print("start user_info")
        let post: [String: Any] = [:]
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_info")
    }
    
    //
    func loadOpenOrders(limit: Int, offset: Int)-> Data? {
        print("start user_opened_orders")
        var post: [String: Any] = [:]
        post["limit"] = limit
        post["offset"] = offset
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_open_orders")
    }
    
    func loadCanceledOrders(limit: Int, offset: Int)-> Data? {
        print("start user_cancelled_orders")
        var post: [String: Any] = [:]
        post["limit"] = limit
        post["offset"] = offset
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_cancelled_orders")
    }
    
    func loadUserTrades(limit: Int = 100, offset: Int = 0, pairs: String = "")-> Data? {
        print("start user_trades")
        var post: [String: Any] = [:]
        post["pair"] = pairs
        post["limit"] = limit
        post["offset"] = offset
        return self.getResponseFromServerForPost(postDictionary: post, method: "user_trades")
    }
    
    
    func createOrder(pair: String, quantity: Double, price: Double, type: String) -> Data? {
        print("start order_create")
        var post: [String: Any] = [:]
        post["pair"] = pair
        post["quantity"] = quantity
        post["price"] = price
        post["type"] = type
        return self.getResponseFromServerForPost(postDictionary: post, method: "order_create")
    }

    func cancelOrder(id: Int64)-> Data? {
        print("start order_cancel")
        var post: [String: Any] = [:]
        post["order_id"] = id
        return self.getResponseFromServerForPost(postDictionary: post, method: "order_cancel")
    }
}

//
// @MARK: public methods
//
extension ExmoApiHandler {
    func loadTicker() -> Data? {
        print("call method loadTicker")
        return self.getResponseFromServerForPost(postDictionary: [:], method: "ticker")
    }
    
    func loadCurrencyPairSettings() -> Data? {
        print("start loadCurrencyPairSettings")
        return self.getResponseFromServerForPost(postDictionary: [:], method: "pair_settings")
    }
    
    func loadCurrencyPairChartHistory(currencyPair: String) {
        print("start loadCurrencyPairSettings")

        Alamofire.request("https://exmo.com/ctrl/chart/history?symbol=\(currencyPair)&resolution=D&from=1533848754&to=1536440814").responseJSON { response in
            AppDelegate.exmoController.handleLoadedCurrencyPairChartHistory(response: response)
        }
    }
}

struct ExmoChartData : Mappable {
    class CandleDataTransformType : TransformType {
        typealias Object = CandleData
        typealias JSON = String
        
        func transformFromJSON(_ value: Any?) -> ExmoChartData.CandleDataTransformType.Object? {
            guard let jsonStr = value as? String else {
                return nil
            }
            return CandleData(JSONString: jsonStr)
        }
        
        func transformToJSON(_ value: ExmoChartData.CandleDataTransformType.Object?) -> ExmoChartData.CandleDataTransformType.JSON? {
            return nil
        }
    }
    
    struct CandleData : Mappable {
        var high: Double = 0.0
        var low: Double = 0.0
        var open: Double = 0.0
        var close: Double = 0.0
        var volume: Double = 0.0
        var timeSince1970InSec: Double = 0.0
        
        init?(map: Map) {
            // do nothing
        }
        
        mutating func mapping(map: Map) {
            high <- map["h"]
            low <- map["l"]
            open <- map["o"]
            close <- map["c"]
            timeSince1970InSec <- map["t"]
            volume <- map["v"]
        }
    }
    
    var candles: [CandleData] = []
    
    init() {
        // do nothing
    }
    
    init?(map: Map) {
        // do nothing
    }
    
    mutating func mapping(map: Map) {
        candles <- map["candles"]
    }
    
    mutating func saveFirst30Elements() {
        if candles.count > 30 {
            candles.removeLast(candles.count - 30)
        }
    }
    
    func getMinVolume() -> Double {
        guard let candleData = candles.min(by: { $0.volume < $1.volume }) else {
            return 0.0
        }
        return candleData.volume
    }
    
    func getMinLow() -> Double {
        guard let candleData = candles.min(by: { $0.low < $1.low }) else {
            return 0.0
        }
        return candleData.low
    }
}

class ExmoAccountController {
    func handleLoadedCurrencyPairChartHistory(response: DataResponse<Any>) {
        print("Result is : \(response.result)")
        switch response.result {
        case .success(_):
            do {
                let jsonStr = try JSON(data: response.data!)
                print("JSON: \(jsonStr)")
                var chartData = ExmoChartData(JSONString: jsonStr.description)
                chartData?.saveFirst30Elements()
                AppDelegate.notificationController.postBroadcastMessage(name: .LoadCurrencyPairChartDataSuccess, data: ["data": chartData as Any])
            } catch {
                AppDelegate.notificationController.postBroadcastMessage(name: .LoadCurrencyPairChartDataFailed)
            }
        case .failure(_):
            AppDelegate.notificationController.postBroadcastMessage(name: .LoadCurrencyPairChartDataFailed)
        }
    }
    
    func getAllCurrenciesOnExmo() -> [String] { // TODO-REF: use cache instead this. cache should update every login
        return [
            "USD","EUR","RUB","PLN","UAH","BTC","LTC","DOGE","DASH","ETH","WAVES","ZEC","USDT","XMR","XRP","KICK","ETC","BCH"
        ]
    }
    
    func getAllPairsOnExmo() -> [String] {
        let currencies = getAllCurrenciesOnExmo()
        var allCombOfCurrencies = [String]()
        
        for currencyPart1 in currencies {
            for currencyPart2 in currencies {
                if currencyPart1 != currencyPart2 {
                    allCombOfCurrencies.append(currencyPart1 + "_" + currencyPart2)
                }
            }
        }
        
        return allCombOfCurrencies
    }
    
    func getAllPairsOnExmoAsStr(separator: String = ",") -> String {
        return getAllPairsOnExmo().joined(separator: separator)
    }
    
    func loadOpenOrders(limit: Int, offset: Int) -> OrdersModel? {
        guard let responseData = ExmoApiHandler.shared.loadOpenOrders(limit: limit, offset: offset) else {
            print("loadOpenOrders: responseData is nil")
            return nil
        }
        
        let jsonString = String(data: responseData, encoding: .utf8)
        if let requestError = RequestResult(JSONString: jsonString!) {
            if requestError.error != nil {
                print("error details: \(requestError.error!)")
                AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
                return nil
            }
        }
        
        do {
            let orders = try OrdersModel(json: JSON(data: responseData))
            return orders
        } catch {
            print("caught json error in method: loadOpenOrders")
        }
        return nil
    }
    
    func loadCanceledOrders(limit: Int, offset: Int) -> OrdersModel? {
        guard let responseData = ExmoApiHandler.shared.loadCanceledOrders(limit: limit, offset: offset) else {
            print("loadCanceledOrders: responseData is nil")
            return nil
        }
        
        let jsonString = String(data: responseData, encoding: .utf8)
        if let requestError = RequestResult(JSONString: jsonString!) {
            if requestError.error != nil {
                print("error details: \(requestError.error!)")
                AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
                return nil
            }
        }
        
        do {
            let orders = try OrdersModel(json: JSON(data: responseData))
            return orders
        } catch {
            print("caught json error in method: loadCanceledOrders")
        }
        return nil
    }
    
    func loadDeals(limit: Int = 1000, offset: Int = 0) -> OrdersModel? {
        guard let responseData = ExmoApiHandler.shared.loadUserTrades(limit: limit, offset: offset, pairs: "XRP_USD") else {
            print("loadDeals: responseData is nil")
            return nil
        }
        
        let jsonString = String(data: responseData, encoding: .utf8)
        if let requestError = RequestResult(JSONString: jsonString!) {
            if requestError.error != nil {
                print("error details: \(requestError.error!)")
                AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
                return nil
            }
        }
        
        do {
            let orders = try OrdersModel(json: JSON(data: responseData))
            return orders
        } catch {
            print("caught json error in method: loadDeals")
        }
        
        return nil
    }
    
    //
    func createOrder(pair: String, quantity: Double, price: Double, type: String) -> OrderRequestResult? {
        guard let responseData = ExmoApiHandler.shared.createOrder(pair: pair, quantity: quantity, price: price, type: type) else {
            print("createOrder: empty data")
            return nil
        }
        
        let jsonString = String(data: responseData, encoding: .utf8)
        if let response = OrderRequestResult(JSONString: jsonString!) {
            if !response.result {
                print("error details: \(response.error!)")
                return nil
            }
            return response
        }
        
        return nil
    }
    
    func cancelOrder(id: Int64) -> Bool {
        guard let responseData = ExmoApiHandler.shared.cancelOrder(id: id) else {
            print("cancelOrder: empty data")
            return false
        }
        
        let jsonString = String(data: responseData, encoding: .utf8)
        if let requestResult = RequestResult(JSONString: jsonString!) {
            if requestResult.error != nil {
                print("cancelOrder: \(requestResult.error!)")
            }
            return requestResult.result
        }
        
        return false
    }
}

extension ExmoAccountController {
    func loadCurrencyPairChartHistory(rawCurrencyPair: String) {
        ExmoApiHandler.shared.loadCurrencyPairChartHistory(currencyPair: rawCurrencyPair)
    }
    
    func loadTickerData() -> [SearchCurrencyPairModel]? {
        let result = ExmoApiHandler.shared.loadTicker()
        guard let jsonString = String(data: result!, encoding: .utf8) else {
            print("loadTickerData: jsonString got cast error")
            return nil
        }
        
        print("loaded: \(jsonString)")
        
        if let requestError = RequestResult(JSONString: jsonString) {
            if requestError.error != nil {
                print("error details: \(requestError.error!)")
                return nil
            }
        }
        
        let json = JSON(parseJSON: jsonString)
        
        
        var currencies: [SearchCurrencyPairModel] = []
        var index: Int = 1
        for (currencyPairName, currencyInfoAsJson) in json {
            let price = currencyInfoAsJson["last_trade"].doubleValue
            currencies.append(SearchCurrencyPairModel(id: index, name: currencyPairName, price: price))
            index += 1
        }
        
        return currencies
    }
    
    func loadCurrencyPairSettings(_ currencyPairName: String) -> OrderSettings? {
        guard let responseData = ExmoApiHandler.shared.loadCurrencyPairSettings() else {
            print("loadCurrencyPairSettings: empty data")
            return nil
        }
        
        guard let jsonString = String(data: responseData, encoding: .utf8) else {
            print("json string is broken")
            return nil
        }
        
        if let response = OrderRequestResult(JSONString: jsonString) {
            if response.error != nil && !response.result {
                print("error details: \(response.error!)")
                return nil
            }
            
            let json = JSON(parseJSON: jsonString)
            guard let settingsAsDict = json.dictionaryValue.first(where: { $0.key == currencyPairName }) else {
                return nil
            }
            
            var dictWithNumbers: [String: Double] = [:]
            for (key, value) in settingsAsDict.value.dictionaryValue {
                dictWithNumbers[key] = value.doubleValue
            }
            
            guard var orderSettings = OrderSettings(JSON: dictWithNumbers) else {
                return nil
            }
            orderSettings.currencyPair = settingsAsDict.key
            
            return orderSettings
        }
        
        return nil
    }
}

extension ExmoAccountController {
    func login(apiKey: String, secretKey: String) {
        ExmoApiHandler.shared.setAuthorizationData(apiKey: apiKey, secretKey: secretKey)
        
        let result = ExmoApiHandler.shared.loadUserInfo()
        let jsonString = String(data: result!, encoding: .utf8)
        
        print("loaded exmo userInfo: \(jsonString!)")
        
        if let requestError = RequestResult(JSONString: jsonString!) {
            if requestError.error != nil {
                print("qr data doesn't validate: \(requestError.error!)")
                AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
                return
            }
        }
        
        guard let userData = User(JSONString: jsonString!) else {
            AppDelegate.notificationController.postBroadcastMessage(name: .UserFailSignIn)
            return
        }
        
        if let walletInfo = WalletModel(JSONString: jsonString!) {
            userData.walletInfo = walletInfo
        }
        userData.qrModel = QRLoginModel(exmoIdentifier: SDefaultValues.ExmoIdentifier.rawValue, key: apiKey, secret: secretKey)
        
        AppDelegate.session.setUserModel(userData: userData, shouldSaveUserInCache: true)
    }
}
