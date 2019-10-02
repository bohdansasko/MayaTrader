//
//  CHCurrencyChartViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/25/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts
import RxSwift

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
        
        setupTitleView()
        
        candlePresenter = CHCandleChartPresenter(chartView: contentView.candleChartView)
        candlePresenter.delegate = self
        
        barPresenter    = CHBarChartPresenter(chartView: contentView.barChartView)
        barPresenter.delegate = self
        
        contentView.set(periodsDelegate: self)
        contentView.set(selectedPeriod: .month, triggerDelegate: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = DisposeBag()
    }

    deinit {
        log.debug("☠️ deinit")
    }
    
}

// MARK: - Setup

private extension CHCurrencyChartViewController {

    func setupTitleView() {
        let stockName    = currency.stock.description
        let currencyName = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currency.name)
        
        let titleView = CHCurrencyTitleView.loadViewFromNib()
        titleView.set(stock: stockName, currency: currencyName)
        navigationItem.titleView = titleView
    }

}

// MARK: - Setters

private extension CHCurrencyChartViewController {

    func set(candles: [CHCandleModel]) {
        candlePresenter.candles = candles
        barPresenter.candles    = candles
    }

}

// MARK: - API

private extension CHCurrencyChartViewController {

    func fetchCandles(for period: CHPeriod) {
        let request = vinsoAPI.rx.getCurrencyCandles(
            name  : currency.name,
            stock : currency.stock,
            period: period,
            limit : 30,
            offset: 0
        )

        rx.showLoadingView(fullscreen: true, request: request).subscribe(
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

// MARK: - CHChartPeriodViewDelegate

extension CHCurrencyChartViewController: CHChartPeriodViewDelegate {
    
    func chartPeriodView(_ periodView: CHChartPeriodsView, didSelect period: CHPeriod) {
        contentView.set(selectedPeriod: period)
        contentView.set(candleDetails: nil)
        fetchCandles(for: period)
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
