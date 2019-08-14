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

struct ConnectionConfig {
    static let exmoUrl   = "exmo.me"
    static let apiUrl    = "https://api.\(exmoUrl)/v1/"
    static var apiKey    = "your_key"
    static var apiSecret = "your_secret"
    static var nonce     = "Nonce"
}

enum MethodId: String {
    case userInfo        = "user_info"
    case openOrders      = "user_open_orders"
    case cancelledOrders = "user_cancelled_orders"
    case userTrades      = "user_trades"
    case orderCreate     = "order_create"
    case orderCancel     = "order_cancel"
    case ticker          = "ticker"
    case pairSettings    = "pair_settings"
}

final class ExmoApiRequestsBuilder {
    static let shared = ExmoApiRequestsBuilder()
    
    private init() {}
}


