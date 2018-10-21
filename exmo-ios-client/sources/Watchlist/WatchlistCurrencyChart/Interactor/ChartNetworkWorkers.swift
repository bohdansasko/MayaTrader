//
// Created by Bogdan Sasko on 9/30/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkWorker {
    func handleResponse(response: DataResponse<Any>)
    var onHandleResponseSuccesfull: ((Any) -> Void)? { get set }
}

extension NetworkWorker {
    func handleResponse(response: DataResponse<Any>) {
        print("default result is : \(response.result)")
        switch response.result {
        case .success(_):
            do {
                let jsonStr = try JSON(data: response.data!)
                print("default JSON: \(jsonStr)")
                onHandleResponseSuccesfull?(jsonStr)
            } catch {
                print("NetworkWorker: we caught a problem in handle response")
            }
        case .failure(_):
            print("NetworkWorker: failure loading chart data")
        }
    }
}

protocol BaseAPICandleChartNetworkWorker: NetworkWorker {
    func loadCurrencyPairChartHistory(currencyPair: String, period: String)
}

class DefaultCandleChartNetworkWorker: BaseAPICandleChartNetworkWorker {
    var onHandleResponseSuccesfull: ((Any) -> Void)?
    
    func loadCurrencyPairChartHistory(currencyPair: String, period: String) {
        Alamofire.request("https://exmo.com/ctrl/chartMain?type=undefined&period=\(period)&para=\(currencyPair)").responseJSON {
            [weak self] response in
            self?.handleResponse(response: response)
        }
    }
}

class ProfessionalCandleChartNetworkWorker: NetworkWorker {
    var onHandleResponseSuccesfull: ((Any) -> Void)? = nil
    
    func loadCurrencyPairChartHistory(currencyPair: String, period: String) {
        Alamofire.request("https://exmo.com/ctrl/chart/history?symbol=\(currencyPair)&resolution=D&from=1533848754&to=1536440814").responseJSON {
            [weak self] response in
            self?.handleResponse(response: response)
        }
    }
    // TODO: refactoring
    func handleResponse(response: DataResponse<Any>) {
        print("Result is : \(response.result)")
        switch response.result {
        case .success(_):
            do {
                let jsonStr = try JSON(data: response.data!)
                print("professional JSON: \(jsonStr)")
                var chartData = ExmoChartData(json: jsonStr, parseType: .Professional)
                chartData.saveFirst30Elements()
                
            } catch {
                
            }
        case .failure(_):
            print("ProfessionalCandleChartNetworkWorker: failure loading chart data")
        }
    }
}
