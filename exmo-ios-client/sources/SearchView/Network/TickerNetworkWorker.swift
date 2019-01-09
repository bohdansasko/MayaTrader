//
//  TickerNetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/18/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Alamofire
import SwiftyJSON

class TickerNetworkWorker: ITickerNetworkWorker {
    weak var delegate: ITickerNetworkWorkerDelegate?
    
    func load() {
        let request = ExmoApiRequestBuilder.shared.getTickerRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            guard let strongSelf = self else { return }

            switch response.result {
            case .success(_):
                strongSelf.delegate?.onDidLoadTickerSuccess(strongSelf.parseResponseIntoModel(response))
            case .failure(_):
                strongSelf.delegate?.onDidLoadTickerFails(strongSelf.parseResponseIntoModel(response))
            }
        }
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
}

extension TickerNetworkWorker {
    fileprivate func parseResponseIntoModel(_ response: DataResponse<Any>) -> Ticker? {
        do {
            guard let responseData = response.data else { return nil }
            let json = try JSON(data: responseData)
            return Ticker(JSON: json["data"]["ticker"].dictionaryValue)
        } catch {
            return nil
        }
    }
}
