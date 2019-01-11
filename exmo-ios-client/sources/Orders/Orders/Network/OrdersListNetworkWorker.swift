//
//  OrdersListNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/12/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class ExmoOrdersListNetworkWorker: IOrdersListNetworkWorker {
    var delegate: IOrdersListNetworkWorkerDelegate?
    
    func loadAllOrders() {
        loadOpenOrders()
        loadCanceledOrders()
        loadDeals()
    }
    
    func loadOpenOrders() {
        let request = ExmoApiRequestBuilder.shared.getOpenOrdersRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            guard let strongSelf = self else { return }
            switch response.result {
            case .success(_):
                strongSelf.delegate?.onDidLoadSuccessOpenOrders(orders: strongSelf.parseResponseIntoModel(response, .open))
            case .failure(_):
                strongSelf.delegate?.onDidLoadFailsOpenOrders(orders: Orders())
            }
        }
    }
    
    func loadCanceledOrders() {
        let request = ExmoApiRequestBuilder.shared.getCanceledOrdersRequest(limit: 100, offset: 0)
        Alamofire.request(request).responseJSON {
            [weak self] response in
            guard let strongSelf = self else { return }
            switch response.result {
            case .success(_):
                strongSelf.delegate?.onDidLoadSuccessCanceledOrders(orders: strongSelf.parseResponseIntoModel(response, .canceled))
            case .failure(_):
                strongSelf.delegate?.onDidLoadFailsCanceledOrders(orders: Orders())
            }
        }
    }
    
    func getAllCurrencies(response: DataResponse<Any>) -> String {
        var currenciesStr = ""
        do {
            let json = try JSON(data: response.data!)
            json.forEach({
                (code, properties) in
                currenciesStr = currenciesStr + code + ","
            })
        } catch {
            
        }
        
        return currenciesStr
    }
    
    func loadDeals() {
        let pairSettingsRequest = ExmoApiRequestBuilder.shared.getCurrencyPairSettingsRequest()
        Alamofire.request(pairSettingsRequest).responseJSON {
            [weak self] response in
            guard let strongSelf = self else { return }
            
            let allCurrencies = strongSelf.getAllCurrencies(response: response)
            let request = ExmoApiRequestBuilder.shared.getUserTradesRequest(limit: 100, offset: 0, pairs: allCurrencies)
            
            Alamofire.request(request).responseJSON {
                [weak self] response in
                guard let strongSelf = self else { return }
                switch response.result {
                case .success(_):
                    strongSelf.delegate?.onDidLoadSuccessDeals(orders: strongSelf.parseResponseIntoModel(response, .deals))
                case .failure(_):
                    strongSelf.delegate?.onDidLoadFailsDeals(orders: Orders())
                }
            }
        }
        
    }

    var ordersForCancel: [Int64] = []
    var cancelledOrdersSuccess: [Int64] = []
    var cancelledOrdersFail: [Int64] = []
    var countOrdersForCancel: Int = 0

    func cancelOrder(id: Int64) {
        let request = ExmoApiRequestBuilder.shared.getCancelOrderRequest(id: id)
        Alamofire.request(request).responseJSON {
            [weak self] jsonResponse in
            guard let strongSelf = self else {
                print("should handle this bad situation")
                return
            }

            switch (jsonResponse.result) {
            case .success(let data):
                guard let exmoResponseResult = Mapper<ExmoResponseResult>().map(JSONObject: data) else {
                    strongSelf.delegate?.onDidCancelOrderFail(errorDescription: "Error: can't get order result")
                    return
                }
                
                if exmoResponseResult.result {
                    strongSelf.cancelledOrdersSuccess.append(id)
                    strongSelf.cancelOrders(ids: strongSelf.ordersForCancel)
                } else {
//                    strongSelf.cancelledOrdersFail.append(id)
                    strongSelf.delegate?.onDidCancelOrderFail(errorDescription: exmoResponseResult.error ?? "Undefined error")
                }
            case .failure(let error):
//                strongSelf.cancelledOrdersFail.append(id)
                strongSelf.delegate?.onDidCancelOrderFail(errorDescription: "Undefined error\(error)")
            }

            if strongSelf.cancelledOrdersSuccess.count == strongSelf.countOrdersForCancel {
                strongSelf.delegate?.onDidCancelOrdersSuccess(ids: strongSelf.cancelledOrdersSuccess)
                strongSelf.ordersForCancel = []
                strongSelf.cancelledOrdersSuccess = []
            }
        }
    }

    func cancelOrders(ids: [Int64]) {
        if ordersForCancel.isEmpty && !ids.isEmpty {
            countOrdersForCancel = ids.count
            ordersForCancel.append(contentsOf: ids)
        }

        if let firstId = ordersForCancel.first {
            ordersForCancel.removeFirst()
            cancelOrder(id: firstId)
        }
    }

    private func parseResponseIntoModel(_ response: DataResponse<Any>, _ displayOrderType: Orders.DisplayType) -> Orders {
        do {
            guard let responseData = response.data else { return Orders() }
            let json = try JSON(data: responseData)
            return Orders(json: json, displayType: displayOrderType)
        } catch {
            return Orders()
        }
    }
}
