//
//  CreateOrderCreateOrderInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class CreateOrderInteractor: CreateOrderInteractorInput {

    weak var output: CreateOrderInteractorOutput!

    private var data: [SearchCurrencyPairModel]
    private var currencyId: Int = -1

    init() {
        self.data = AppDelegate.session.getSearchCurrenciesContainer()
    }

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
