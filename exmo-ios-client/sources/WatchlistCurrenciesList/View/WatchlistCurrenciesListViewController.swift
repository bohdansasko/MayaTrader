//
//  WatchlistCurrenciesListWatchlistCurrenciesListViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrenciesListViewController: UIViewController, WatchlistCurrenciesListViewInput {

    var output: WatchlistCurrenciesListViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: WatchlistCurrenciesListViewInput
    func setupInitialState() {
    }
}
