//
//  CreateOrderCreateOrderInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class CreateOrderInteractor: CreateOrderInteractorInput {

    weak var output: CreateOrderInteractorOutput!

    private var data = [
        SearchCurrencyPairModel(id: 1, name: "BTC/USD", price: 7809.976),
        SearchCurrencyPairModel(id: 2, name: "BTC/EUR", price: 6009.65),
        SearchCurrencyPairModel(id: 3, name: "BTC/UAH", price: 51090.0),
        SearchCurrencyPairModel(id: 4, name: "EUR/USD", price: 109.976),
        SearchCurrencyPairModel(id: 5, name: "UAH/USD", price: 709.976),
        SearchCurrencyPairModel(id: 6, name: "UAH/BTC", price: 809.976),
        SearchCurrencyPairModel(id: 7, name: "EUR/BTC", price: 9871.976)
    ]
    private var currencyId: Int = -1
    
    func createOrder(orderModel: OrderModel) {
        print("func createOrder called")
    }
    
    func handleSelectedCurrency(currencyId: Int) {
        self.currencyId = currencyId
        guard let currencyData = self.data.first(where: {$0.id == currencyId}) else {
            return
        }
        self.output.updateSelectedCurrency(name: currencyData.name, price: currencyData.price)
    }
}
