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
        let request = ExmoApiRequestBuilder.shared.getCreateOrderRequest(
                    pair: order.currencyPair,
                quantity: order.quantity,
                   price: order.price,
                    type: order.getCreateTypeAsStr())

        Alamofire.request(request).responseJSON {
            [weak self] response in
            switch response.result {
            case .success(let data):
                guard let createOrderReponseResult = Mapper<OrderExmoResponseResult>().map(JSONObject: data) else {
                    return
                }
                if createOrderReponseResult.result == true && createOrderReponseResult.id > 0 {
                    self?.delegate?.onDidCreateOrderSuccess()
                } else {
                    self?.delegate?.onDidCreateOrderFail(errorMessage: createOrderReponseResult.error ?? "Undefined error")
                }
            case .failure(let error):
                self?.delegate?.onDidCreateOrderFail(errorMessage: error.localizedDescription)
            }
        }
    }
}
