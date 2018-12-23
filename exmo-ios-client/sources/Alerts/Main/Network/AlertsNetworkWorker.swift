//
//  AlertsNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import ObjectMapper


protocol IVinsoAlertsApiRequestBuilder {
    static func getAlertsHistoryRequest() -> URLRequest
    static func getCreateAlertRequest() -> URLRequest
    static func getDeleteAlertRequest() -> URLRequest
}

class VinsoAlertsApiRequestBuilder: IVinsoAlertsApiRequestBuilder {
    private init() {
        // do nothing
    }
    
    static func getAlertsHistoryRequest() -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
    
    static func getCreateAlertRequest() -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
    
    static func getDeleteAlertRequest() -> URLRequest {
        return URLRequest(url: URL(string: "")!)
    }
}

class VinsoAlertsNetworkWorker : IAlertsNetworkWorker {
    weak var delegate: IAlertsNetworkWorkerDelegate!
    
    func loadHistory() {
        let request = VinsoAlertsApiRequestBuilder.getAlertsHistoryRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            self?.onDidLoadResponse(response)
        }
    }

    private func onDidLoadResponse(_ response: DataResponse<Any>) {
        switch response.result {
        case .success(let data):
            print("did load alerts json: ", data)
            guard let _ = Mapper<ExmoResponseResult>().map(JSONObject: data) else {
                delegate.onDidLoadAlertsHistoryFail(messageError: "Undefined error")
                return
            }
//            guard let wallet = ExmoWalletObject(JSONString: json.description) else { return }
//            delegate.onDidLoadAlertsHistorySuccessful(wallet)
        case .failure(let error):
            delegate.onDidLoadAlertsHistoryFail(messageError: "Alerts error: \(error.localizedDescription)")
        }
    }
}
