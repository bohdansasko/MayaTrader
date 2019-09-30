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
    
    // MARK: - Private variables
    
    fileprivate var candlePresenter: CHCandleChartPresenter!
    fileprivate var barPresenter   : CHBarChartPresenter!
    
    // MARK: - Public variables
    
    var currency: CHLiteCurrencyModel! {
        didSet { assert(!self.isViewLoaded) }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(currency != nil, "required")
        
        titleNavBar     = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currency.name)
        
        candlePresenter = CHCandleChartPresenter(chartView: contentView.candleChartView)
        barPresenter    = CHBarChartPresenter(chartView: contentView.barChartView)
        
        fetchCurrencyInfo(for: contentView.periodsView.selectedItem)
    }

}

private extension CHCurrencyChartViewController {

    func fetchCurrencyInfo(for period: CHPeriod) {
        let request = vinsoAPI.rx.getCurrencyCandles(name: currency.name, stock: currency.stock, period: period, limit: 20, offset: 0)
        rx.showLoadingView(request: request).subscribe(
            onSuccess: { [weak self] c in
                guard let `self` = self else { return }
                self.set(candles: c)
            }, onError: { [weak self] err in
                guard let `self` = self else { return }
                self.handleError(err)
            }
        ).disposed(by: disposeBag)
    }

}

private extension CHCurrencyChartViewController {

    func set(candles: [CHCandleModel]) {

    }

}