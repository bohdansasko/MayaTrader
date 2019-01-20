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
    private var timerScheduler: Timer?

    deinit {
        print("deinit \(String(describing: self))")
    }

    func load() {
        let request = ExmoApiRequestBuilder.shared.getTickerRequest()
        Alamofire.request(request).responseJSON {
            [weak self] response in
            guard let strongSelf = self else { return }

            switch response.result {
            case .success(_):
                strongSelf.delegate?.onDidLoadTickerSuccess(strongSelf.parseResponseIntoModel(response))
            case .failure(_):
                strongSelf.delegate?.onDidLoadTickerFails()
            }
        }
    }

    func load(timeout: Double, repeat: Bool) {
        print("\(String(describing: self)): \(#function)")
        timerScheduler = Timer.scheduledTimer(withTimeInterval: FrequencyUpdateInSec.watchlist, repeats: true) {
            [weak self] _ in
            self?.load()
        }
        load()
    }

    func cancelRepeatLoads() {
        print("\(String(describing: self)): \(#function)")
        if timerScheduler != nil {
            timerScheduler?.invalidate()
            timerScheduler = nil
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