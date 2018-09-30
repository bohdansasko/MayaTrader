//
// Created by Bogdan Sasko on 9/30/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkWorker {
    func handleResponse(response: DataResponse<Any>)
    var onHandleResponseSuccesfull: ((ExmoChartData) -> Void)? { get set }
}

protocol BaseAPICandleChartNetworkWorker: NetworkWorker {
    func loadCurrencyPairChartHistory(currencyPair: String, period: String)
}

class DefaultCandleChartNetworkWorker: BaseAPICandleChartNetworkWorker {
    var onHandleResponseSuccesfull: ((ExmoChartData) -> Void)? = nil
    
    func loadCurrencyPairChartHistory(currencyPair: String, period: String) {
        Alamofire.request("https://exmo.com/ctrl/chartMain?type=undefined&period=\(period)&para=\(currencyPair)").responseJSON {
            [weak self] response in
            self?.handleResponse(response: response)
        }
    }

    func handleResponse(response: DataResponse<Any>) {
        print("default result is : \(response.result)")
        switch response.result {
        case .success(_):
            do {
                let jsonStr = try JSON(data: response.data!)
                print("default JSON: \(jsonStr)")

                let chartData = ExmoChartData(json: jsonStr, parseType: .Default)
                print(chartData)
                onHandleResponseSuccesfull?(chartData)
            } catch {
                print("DefaultCandleChartNetworkWorker: we caught a problem in handle response")
            }
        case .failure(_):
            print("DefaultCandleChartNetworkWorker: failure loading chart data")
        }
    }
}

class ProfessionalCandleChartNetworkWorker: NetworkWorker {
    var onHandleResponseSuccesfull: ((ExmoChartData) -> Void)? = nil
    
    func loadCurrencyPairChartHistory(currencyPair: String, period: String) {
        Alamofire.request("https://exmo.com/ctrl/chart/history?symbol=\(currencyPair)&resolution=D&from=1533848754&to=1536440814").responseJSON {
            [weak self] response in
            self?.handleResponse(response: response)
        }
    }

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
