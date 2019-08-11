//
//  OrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class OrdersPresenter {
    weak var view: OrdersViewInput!
    var interactor: OrdersInteractorInput!
    var router: OrdersRouterInput!
}

// MARK: OrdersViewOutput
extension OrdersPresenter: OrdersViewOutput {
    func viewIsReady() {
        interactor.viewIsReady()
    }

    func viewWillAppear() {
        interactor.viewWillAppear()
    }
    
    func onDidSelectTab(_ orderTab: Orders.DisplayType) {
        interactor.loadOrderByType(orderTab)
    }
    
    func onTouchButtonAddOrder() {
        if let viewController = view as? UIViewController {
            router.showAddOrderVC(viewController)
        }
    }
    
    func cancelOrder(ids: [Int64]) {
        interactor.cancelOrder(ids: ids)
    }
}

// MARK: OrdersInteractorOutput
extension OrdersPresenter: OrdersInteractorOutput {
    func onDidLoadOrders(loadedOrders: [Orders.DisplayType : Orders]) {
        view.updateOrders(loadedOrders: loadedOrders)
    }
    
    func orderCancelled(ids: [Int64]) {
        view.orderCancelled(ids: ids)
    }

    func setSubscription(_ package: CHSubscriptionPackageProtocol) {
        view.setSubscription(package)
    }

    func purchaseError(reason: String) {
        view.showAlert(msg: reason)
    }
}
