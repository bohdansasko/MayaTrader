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
    private var timerRepeater: Timer?
    private(set) var isLoadCanceled: Bool = false

    deinit {
        print("deinit \(String(describing: self))")
    }

    func load() {
        isLoadCanceled = false

        let request = ExmoApiRequestBuilder.shared.getTickerRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            guard let strongSelf = self, !strongSelf.isLoadCanceled else { return }

            switch response.result {
            case .success(_):
                strongSelf.delegate?.onDidLoadTickerSuccess(strongSelf.parseResponseIntoModel(response))
            case .failure(_):
                strongSelf.delegate?.onDidLoadTickerFails()
            }
        }
    }

    func load(timeout: Double, repeat: Bool) {
        if timerRepeater != nil {
            load()
            return
        }

        print("\(String(describing: self)): \(#function)")
        timerRepeater = Timer.scheduledTimer(withTimeInterval: FrequencyUpdateInSec.watchlist, repeats: true) {
            [weak self] _ in
            self?.load()
        }
        load()
    }

    func cancelRepeatLoads() {
        print("\(String(describing: self)): \(#function)")
        if timerRepeater != nil {
            isLoadCanceled = true
            timerRepeater?.invalidate()
            timerRepeater = nil
        }
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