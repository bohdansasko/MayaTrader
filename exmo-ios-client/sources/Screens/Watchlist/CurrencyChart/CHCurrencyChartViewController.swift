//
//  CHCurrencyChartViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/25/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts

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
        candlePresenter.delegate = self
        
        barPresenter    = CHBarChartPresenter(chartView: contentView.barChartView)
        barPresenter.delegate = self
        
        contentView.set(selectedPeriod: .month)
        contentView.set(periodsDelegate: self)
        
        fetchCurrencyInfo(for: .month)
    }
    
    deinit {
        log.debug("☠️ deinit")
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
        candlePresenter.candles = candles
        barPresenter.candles    = candles
    }

}

// MARK: - CHChartPeriodViewDelegate

extension CHCurrencyChartViewController: CHChartPeriodViewDelegate {
    
    func chartPeriodView(_ periodView: CHChartPeriodsView, didSelect period: CHPeriod) {
        periodView.set(selected: period)
    }
    
}

// MARK: - CHBaseChartPresenterDelegate

extension CHCurrencyChartViewController: CHBaseChartPresenterDelegate {

    func chartPresenter(_ presenter: CHBaseChartPresenter, didSelectChartValue value: Highlight) {
        self.candlePresenter.chartView?.highlightValue(value)
        let idx = Int(value.x)
        let candle = self.candlePresenter.candles[idx]
        self.contentView.set(candleDetails: candle)
        
        if presenter is CHCandleChartPresenter {
            self.barPresenter.chartView?.highlightValue(value)
        }
    }
    
    func chartPresenter(_ presenter: CHBaseChartPresenter, didTranslateChartValue value: Highlight) {
        if presenter is CHCandleChartPresenter {
            self.barPresenter.moveChartByXTo(index: value.x)
        } else if presenter is CHBarChartPresenter {
            self.candlePresenter.moveChartByXTo(index: value.x)
        }
    }
    
}
