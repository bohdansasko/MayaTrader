//
//  CHCurrencyChartViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/25/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHCurrencyChartViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHCurrencyChartView
    
    var currency: CHLiteCurrencyModel! {
        didSet { assert(!self.isViewLoaded) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(currency != nil, "required")
        
        titleNavBar = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currency.name)
    }

}
