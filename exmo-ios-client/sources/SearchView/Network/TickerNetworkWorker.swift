//
//  TickerNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Alamofire
import SwiftyJSON

class SearchCurrencyListNetworkWorker: ISearchCurrencyListNetworkWorker {
    weak var delegate: ITickerNetworkWorkerDelegate?
    
    func loadTicker() {
        let request = ExmoApiRequestBuilder.shared.getTickerRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            guard let self = self else { return }
            switch response.result {
            case .success(_):
                self.delegate?.onDidLoadTickerSuccess(self.parseResponseIntoModel(response))
            case .failure(_):
                self.delegate?.onDidLoadTickerFails(self.parseResponseIntoModel(response))
            }
        }
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
}

extension SearchCurrencyListNetworkWorker {
    fileprivate func parseResponseIntoModel(_ response: DataResponse<Any>) -> Ticker? {
        do {
            guard let responseData = response.data else { return nil }
            let json = try JSON(data: responseData)
            return Ticker(JSON: json.dictionaryValue)
        } catch {
            return nil
        }
    }
}
