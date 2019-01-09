//
//  Session.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/7/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

//
// MARK: Test code
//
//extension Session {
//    func initHardcode() {
//        // opened orders
//        self.openedOrders = Orders(orders: [
//            OrderModel(id: 1, orderType: .Buy, currencyPair: "BTC/USD", createdDate: Date(), price: 14234, quantity: 2, amount: 0.5123),
//            OrderModel(id: 2, orderType: .Sell, currencyPair: "BTC/EUR", createdDate: Date(), price: 44186, quantity: 100, amount: 1.5)
//            ])
//
//        // canceled orders
//        let listOfCanceledOrders = [
//            OrderModel(id: 3, orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
//            OrderModel(id: 4, orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15),
//            OrderModel(id: 5, orderType: .Buy, currencyPair: "ZEC/USD", createdDate: Date(), price: 241.44356774, quantity: 192.76358764, amount: 0.79837947),
//            OrderModel(id: 6, orderType: .Sell, currencyPair: "LTC/USD", createdDate: Date(), price: 526.78165001, quantity: 23.77988769, amount: 0.15)
//        ]
//        self.canceledOrders = Orders(orders: listOfCanceledOrders)
//
//        // deals orders
//        let dealsOrders = [
//            OrderModel(id: 7, orderType: .Sell, currencyPair: "ETH/USD", createdDate: Date(), price: 986, quantity: 152.83, amount: 0.155)
//        ]
//        self.dealsOrders = Orders(orders: dealsOrders)
//
//        self.searchCurrenciesContainer = [
//            SearchCurrencyPairModel(id: 1, name: "BTC/USD", price: 7809.976),
//            SearchCurrencyPairModel(id: 2, name: "BTC/EUR", price: 6009.65),
//            SearchCurrencyPairModel(id: 3, name: "BTC/UAH", price: 51090.0),
//            SearchCurrencyPairModel(id: 4, name: "EUR/USD", price: 109.976),
//            SearchCurrencyPairModel(id: 5, name: "UAH/USD", price: 709.976),
//            SearchCurrencyPairModel(id: 6, name: "UAH/BTC", price: 809.976),
//            SearchCurrencyPairModel(id: 7, name: "EUR/BTC", price: 9871.976)
//        ]
//    }
//}
