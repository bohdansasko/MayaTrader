//
//  OrdersInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import Alamofire

class OrdersInteractor {
    weak var output: OrdersInteractorOutput!
    var loadedOrders: [Orders.DisplayType : Orders] = [:]
    var networkWorker: IOrdersListNetworkWorker!
}

// @MARK: OrdersInteractorInput
extension OrdersInteractor: OrdersInteractorInput {
    func viewIsReady() {
        subscribeOnEvents()
        networkWorker.delegate = self
    }
    
    func loadOrderByType(_ orderType: Orders.DisplayType) {
        switch orderType {
        case .Open: networkWorker.loadOpenOrders()
        case .Canceled: networkWorker.loadCanceledOrders()
        case .Deals: networkWorker.loadDeals()
        case .None: break
        }
    }
}

// MARK: load orders and display them
extension OrdersInteractor {
    func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(onUserSignOut), name: .UserSignOut)
    }
    
    @objc func onUserSignOut() {
        output.onDidLoadOrders(loadedOrders: [:])
    }
    
    
    @objc func onAppendOrder(notification: Notification) {
        guard let orderModel = notification.userInfo?["data"] as? OrderModel else {
            print("Can't cast to OrderModel")
            return
        }
//        displayManager.appendOpenOrder(orderModel: orderModel)
    }
}

extension OrdersInteractor: IOrdersListNetworkWorkerDelegate {
    func onDidLoadSuccessOpenOrders(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.Open : orders])
    }
    
    func onDidLoadFailsOpenOrders(orders: Orders) {
        print("onDidLoadFailsOpenOrders")
    }
    
    func onDidLoadSuccessCanceledOrders(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.Canceled : orders])
    }
    
    func onDidLoadFailsCanceledOrders(orders: Orders) {
        print("onDidLoadFailsCanceledOrders")
    }
    
    func onDidLoadSuccessDeals(orders: Orders) {
        output.onDidLoadOrders(loadedOrders: [.Deals : orders])
    }
    
    func onDidLoadFailsDeals(orders: Orders) {
        print("onDidLoadFailsDeals")
    }
}
