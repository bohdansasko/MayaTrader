//
//  OrdersInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation

class OrdersInteractor: OrdersInteractorInput {
    weak var output: OrdersInteractorOutput!
    var loadedOrders: [Orders.DisplayType : Orders] = [:]
}

// @MARK:
extension OrdersInteractor {
    func viewIsReady() {
        subscribeOnEvents()
        loadAllOrders()
    }
}

// MARK: load orders and display them
extension OrdersInteractor {
    func loadAllOrders() {
        if AppDelegate.session.isOpenOrdersLoaded() {
            onDidLoadOrders(orderType: .Open)
        }
        
        if AppDelegate.session.isCanceledOrdersLoaded() {
            onDidLoadOrders(orderType: .Canceled)
        }
        
        if AppDelegate.session.isDealsOrdersLoaded() {
            onDidLoadOrders(orderType: .Deals)
        }
    }
    
    func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(onUserSignOut), name: .UserSignOut)
//        AppDelegate.notificationController.addObserver(self, selector: #selector(onOpenOrdersLoaded), name: .OpenOrdersLoaded)
//        AppDelegate.notificationController.addObserver(self, selector: #selector(onCanceledOrdersLoaded), name: .CanceledOrdersLoaded)
//        AppDelegate.notificationController.addObserver(self, selector: #selector(onDealsOrdersLoaded), name: .DealsOrdersLoaded)
//        AppDelegate.notificationController.addObserver(self, selector: #selector(onAppendOrder), name: .AppendOrder)
    }
    
    @objc func onUserSignIn() {
//        displayManager.updateTableUI()
    }
    
    @objc func onUserSignOut() {
        output.onDidLoadOrders(loadedOrders: [:])
    }
    
    func onDidLoadOrders(orderType: Orders.DisplayType) {
        let orders: Orders!
        switch orderType {
        case .Open: orders = AppDelegate.session.getOpenOrders()
        case .Canceled: orders = AppDelegate.session.getCanceledOrders()
        case .Deals: orders = AppDelegate.session.getDealsOrders()
        default: orders = Orders()
        }
        output.onDidLoadOrders(loadedOrders: [orderType : orders])
    }
    
    @objc func onAppendOrder(notification: Notification) {
        guard let orderModel = notification.userInfo?["data"] as? OrderModel else {
            print("Can't cast to OrderModel")
            return
        }
//        displayManager.appendOpenOrder(orderModel: orderModel)
    }
}
