//
//  WatchlistCurrencyChartWatchlistCurrencyChartInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class WatchlistCurrencyChartInteractor {
    weak var output: WatchlistCurrencyChartInteractorOutput!
    var networkAPIHandler: BaseAPICandleChartNetworkWorker!

    init() {
        subscribeOnIAPNotifications()
    }

    deinit {
        unsubscribeFromNotifications()
    }
}

extension WatchlistCurrencyChartInteractor: WatchlistCurrencyChartInteractorInput {
    func viewWillAppear() {
        output.setSubscription(IAPService.shared.CHSubscriptionPackage)
    }

    func loadCurrencyPairChartHistory(currencyPair: String, period: String = "day") {
        print("start loadCurrencyPairSettings")
        networkAPIHandler.onHandleResponseSuccesfull = {
            [weak self] json in
            guard let jsonObj = json as? JSON else { return }
            let chartData = ExmoChartData(json: jsonObj, parseType: .Default)
            self?.output.updateChart(chartData: chartData)
        }
        networkAPIHandler.loadCurrencyPairChartHistory(currencyPair: currencyPair, period: period)
    }
}

// MARK: subscriptions
extension WatchlistCurrencyChartInteractor {
    func subscribeOnIAPNotifications() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onProductSubscriptionActive(_ :)),
                name: IAPNotification.updateSubscription)
    }

    func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}


extension WatchlistCurrencyChartInteractor {
    @objc
    func onProductSubscriptionActive(_ notification: Notification) {
        print("\(String(describing: self)), \(#function) => notification \(notification.name)")
        guard let CHSubscriptionPackage = notification.userInfo?[IAPService.kSubscriptionPackageKey] as? CHSubscriptionPackageProtocol else {
            print("\(#function) => can't convert notification container to CHSubscriptionPackageProtocol")
            output.setSubscription(CHBasicAdsSubscriptionPackage())
            return
        }
        output.setSubscription(CHSubscriptionPackage)
    }
}
