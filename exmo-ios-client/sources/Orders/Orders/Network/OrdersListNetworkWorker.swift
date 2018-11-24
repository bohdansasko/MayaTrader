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
            guard let self = self else { return }
            switch response.result {
            case .success(_):
                self.delegate?.onDidLoadSuccessOpenOrders(orders: self.parseResponseIntoModel(response))
            case .failure(_):
                self.delegate?.onDidLoadFailsOpenOrders(orders: Orders())
            }
        }
    }
    
    func loadCanceledOrders() {
        let request = ExmoApiRequestBuilder.shared.getCanceledOrdersRequest(limit: 100, offset: 0)
        Alamofire.request(request).responseJSON {
            [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(_):
                self.delegate?.onDidLoadSuccessCanceledOrders(orders: self.parseResponseIntoModel(response))
            case .failure(_):
                self.delegate?.onDidLoadFailsCanceledOrders(orders: Orders())
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
            
            guard let self = self else { return }
            
            let allCurrencies = self.getAllCurrencies(response: response)
            let request = ExmoApiRequestBuilder.shared.getUserTradesRequest(limit: 100, offset: 0, pairs: allCurrencies)
            
            Alamofire.request(request).responseJSON {
                [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success(_):
                    self.delegate?.onDidLoadSuccessDeals(orders: self.parseResponseIntoModel(response))
                case .failure(_):
                    self.delegate?.onDidLoadFailsDeals(orders: Orders())
                }
            }
        }
        
    }
    
    func cancelOrder(id: Int64) {
        let request = ExmoApiRequestBuilder.shared.getCancelOrderRequest(id: id)
        Alamofire.request(request).responseJSON {
            [weak self] jsonResponse in
            switch (jsonResponse.result) {
            case .success(let data):
                guard let exmoResponseResult = Mapper<ExmoResponseResult>().map(JSONObject: data) else {
                    self?.delegate?.onDidCancelOrderFail(errorDescription: "Error: can't get order result")
                    return
                }
                
                if exmoResponseResult.result {
                    self?.delegate?.onDidCancelOrderSuccess(id: id)
                } else {
                    self?.delegate?.onDidCancelOrderFail(errorDescription: exmoResponseResult.error ?? "Undefined error")
                }
            case .failure(let error):
                self?.delegate?.onDidCancelOrderFail(errorDescription: "Undefined error\(error)")
            }
        }
    }

    
    private func parseResponseIntoModel(_ response: DataResponse<Any>) -> Orders {
        do {
            let json = try JSON(data: response.data!)
            return Orders(json: json)
        } catch {
            return Orders()
        }
    }
}
