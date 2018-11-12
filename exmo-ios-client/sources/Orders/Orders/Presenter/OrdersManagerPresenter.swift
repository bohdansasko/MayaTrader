//
//  OrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class OrdersPresenter: OrdersModuleInput, OrdersViewOutput, OrdersInteractorOutput {

    weak var view: OrdersViewInput!
    var interactor: OrdersInteractorInput!
    var router: OrdersRouterInput!

    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func onDidLoadOrders(loadedOrders: [Orders.DisplayType : Orders]) {
        view.updateOrders(loadedOrders: loadedOrders)
    }
    
    func onDidSelectTab(_ orderTab: Orders.DisplayType) {
        interactor.loadOrderByType(orderTab)
    }
}
