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

protocol IOrdersListNetworkWorkerDelegate: class {
    func onDidLoadSuccessOpenOrders(orders: Orders)
    func onDidLoadFailsOpenOrders(orders: Orders)
    
    func onDidLoadSuccessCanceledOrders(orders: Orders)
    func onDidLoadFailsCanceledOrders(orders: Orders)
    
    func onDidLoadSuccessDeals(orders: Orders)
    func onDidLoadFailsDeals(orders: Orders)
}

protocol IOrdersListNetworkWorker {
    var delegate: IOrdersListNetworkWorkerDelegate? { get set }
    
    func loadAllOrders()
    func loadOpenOrders()
    func loadCanceledOrders()
    func loadDeals()
}

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
    
    private func parseResponseIntoModel(_ response: DataResponse<Any>) -> Orders {
        do {
            let json = try JSON(data: response.data!)
            return Orders(json: json)
        } catch {
            return Orders()
        }
    }
}