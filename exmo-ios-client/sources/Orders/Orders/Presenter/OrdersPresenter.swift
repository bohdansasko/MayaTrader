//
//  OrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class OrdersPresenter: OrdersModuleInput {
    weak var view: OrdersViewInput!
    var interactor: OrdersInteractorInput!
    var router: OrdersRouterInput!
}

// @MARK: OrdersViewOutput
extension OrdersPresenter: OrdersViewOutput {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func onDidSelectTab(_ orderTab: Orders.DisplayType) {
        interactor.loadOrderByType(orderTab)
    }
    
    func onTouchButtonAddOrder() {
        router.showAddOrderVC(view as! UIViewController)
    }
    
    func cancelOrder(id: Int64) {
        interactor.cancelOrder(id: id)
    }
}

// @MARK: OrdersInteractorOutput
extension OrdersPresenter: OrdersInteractorOutput {
    func onDidLoadOrders(loadedOrders: [Orders.DisplayType : Orders]) {
        view.updateOrders(loadedOrders: loadedOrders)
    }
    
    func orderCanceled(id: Int64) {
        view.orderCanceled(id: id)
    }
}
