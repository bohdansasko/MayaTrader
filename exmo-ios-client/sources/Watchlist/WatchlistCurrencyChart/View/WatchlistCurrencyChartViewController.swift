//
//  WatchlistCurrencyChartWatchlistCurrencyChartViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrencyChartViewController: UIViewController, WatchlistCurrencyChartViewInput {

    var output: WatchlistCurrencyChartViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: WatchlistCurrencyChartViewInput
    func setupInitialState() {
    }
}
