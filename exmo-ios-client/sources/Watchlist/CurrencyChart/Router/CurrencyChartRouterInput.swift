//
//  WatchlistCurrencyChartWatchlistCurrencyChartRouterInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

protocol WatchlistCurrencyChartRouterInput {
    func showViewAddAlert(_ viewController: UIViewController, pair: String)
    func showViewAddOrder(_ viewController: UIViewController, pair: String)
}
