//
//  CHExmoAPI.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import RxSwift
import Alamofire
import SwiftyJSON

final class CHExmoAPI {
    static let shared = CHExmoAPI()
    
    private init() {}
    
    var isAuthorized: Bool {
        return CHExmoAuthorizationService.shared.isAuthorized
    }
    
    func send(request: URLRequest) -> Observable<JSON> {
        let observable = Observable<JSON>.create{ subscriber in
            let request = Alamofire.request(request).responseJSON { response in
                switch response.result {
                case .success(let object):
                    let json = JSON(object)
                    subscriber.onNext(json)
                    subscriber.onCompleted()
                case .failure(let err):
                    subscriber.onError(err)
                }
            }
            return Disposables.create{ request.cancel() }
        }
        return observable
    }
    
}

// MARK: - Help

extension CHExmoAPI {
    
    func getAllCurrenciesOnExmo() -> [String] { // TODO-REF: use cache instead this. cache should update every login
        return [
            "USD","EUR","RUB","PLN","UAH","BTC","LTC","DOGE","DASH","ETH","WAVES","ZEC","USDT","XMR","XRP","KICK","ETC","BCH"
        ]
    }
    
    func getAllPairsOnExmo() -> [String] { // TODO: check this method, because some currencies doesn't exists
        let currencies = getAllCurrenciesOnExmo()
        var allCombOfCurrencies = [String]()
        
        for currencyPart1 in currencies {
            for currencyPart2 in currencies {
                if currencyPart1 != currencyPart2 {
                    allCombOfCurrencies.append(currencyPart1 + "_" + currencyPart2)
                }
            }
        }
        
        return allCombOfCurrencies
    }
    
    func getAllPairsOnExmoAsStr(separator: String = ",") -> String {
        return getAllPairsOnExmo().joined(separator: separator)
    }
    
}

// MARK: - ReactiveCompatible

extension CHExmoAPI: ReactiveCompatible {}
