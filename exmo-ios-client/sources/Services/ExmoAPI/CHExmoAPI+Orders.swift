//
//  CHExmoAPI+Orders.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/18/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift

extension Reactive where Base: CHExmoAPI {
    
    func getOpenOrders() -> Single<[OrderModel]> {
        let request = ExmoApiRequestsBuilder.shared.getOpenOrdersRequest()
        return self.base.send(request: request)
            .mapInBackground{ json in
                let orders = Orders(json: json, displayType: .open)
                return orders.orders
            }
            .asSingle()
    }
    
    func getCancelledOrders(limit: Int, offset: Int) -> Single<[OrderModel]> {
        let request = ExmoApiRequestsBuilder.shared.getCancelledOrdersRequest(limit: limit, offset: offset)
        return self.base.send(request: request)
            .mapInBackground{ json in
                let orders = Orders(json: json, displayType: .cancelled)
                return orders.orders
            }
            .asSingle()
    }
    
    func getDealsOrders(limit: Int, offset: Int) -> Single<[OrderModel]> {
        let request = ExmoApiRequestsBuilder.shared.getUserTradesRequest(limit: limit, offset: offset)
        return self.base.send(request: request)
            .mapInBackground{ json in
                let orders = Orders(json: json, displayType: .deals)
                return orders.orders
            }
            .asSingle()
    }
    
}
