//
//  OrdersNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class OrdersNetworkWorker: IOrdersNetworkWorker {
    weak var delegate: IOrdersNetworkWorkerDelegate?
    
    func createOrder(order: OrderModel) {
        let request = ExmoApiRequestsBuilder.shared.getCreateOrderRequest(
                    pair: order.currencyPair,
                quantity: order.quantity,
                   price: order.price,
                    type: order.getCreateTypeAsStr())

        Alamofire.request(request).responseJSON {
            [weak self] response in
            switch response.result {
            case .success(let data):
                guard let orderResponse = Mapper<OrderExmoResponseResult>().map(JSONObject: data) else {
                    return
                }
                if orderResponse.base.result == true && orderResponse.id > 0 {
                    self?.delegate?.onDidCreateOrderSuccess()
                } else {
                    self?.delegate?.onDidCreateOrderFail(errorMessage: orderResponse.base.error ?? "Undefined error")
                }
            case .failure(let error):
                self?.delegate?.onDidCreateOrderFail(errorMessage: error.localizedDescription)
            }
        }
    }
}
