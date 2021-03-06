//
//  NetworkWorker.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/30/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol NetworkWorker {
    func handleResponse(response: DataResponse<Any>)
    
    var onHandleResponseSuccesfull: ((Any) -> Void)? { get set }
    
}

extension NetworkWorker {
    func handleResponse(response: DataResponse<Any>) {
        switch response.result {
        case .success(_):
            do {
                let jsonStr = try JSON(data: response.data!)
                onHandleResponseSuccesfull?(jsonStr)
            } catch {
                log.error("NetworkWorker: we caught a problem in handle response")
            }
        case .failure(_):
            log.error("NetworkWorker: failure loading chart data")
        }
    }
}
