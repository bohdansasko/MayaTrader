//
//  WatchlistCurrencyChartWatchlistCurrencyChartViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import Charts

//
// @MARK: WatchlistCurrencyChartViewController
//
class WatchlistCurrencyChartViewController: ExmoUIViewController, WatchlistCurrencyChartViewInput {
    @IBOutlet weak var candleShortInfoView: CandleBarChartShortInfoView!
    @IBOutlet weak var candleChart: CandleStickChartView!
    @IBOutlet weak var barChart: BarChartView!
    
    var output: WatchlistCurrencyChartViewOutput!
    private var chartData: ExmoChartData!
    private var candleChartViewController = CandleStickChartViewController()
    private var barChartViewController = BarChartViewController()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        setupInitialState();
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    
    // MARK: WatchlistCurrencyChartViewInput
    func setupInitialState() {
        candleShortInfoView.isHidden = true
        
        subscribeOnEvents()
        prepareCharts()
        
        AppDelegate.exmoController.loadCurrencyPairChartHistory(rawCurrencyPair: "BTC_USD")
    }
    
    func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(onLoadCurrencyPairChartDataSuccess(notification:)), name: .LoadCurrencyPairChartDataSuccess)
        AppDelegate.notificationController.addObserver(self, selector: #selector(onLoadCurrencyPairChartDataFailed), name: .LoadCurrencyPairChartDataFailed)
    }
    
    private func prepareCharts() {
        barChartViewController.chartView = barChart
        barChartViewController.setCallbackOnChartTranslated(callback: {
            dX in
            self.candleChartViewController.moveChartByXTo(index: Double(dX))
        })
        barChartViewController.setCallbackOnChartValueSelected(callback: {
            candleEntryIndex, volumeValue, secondsSince1970 in
        })
        
        candleChartViewController.chartView = candleChart
        candleChartViewController.setCallbackOnChartTranslated(callback: {
            dX in
            self.barChartViewController.moveChartByXTo(index: Double(dX))
        })
        candleChartViewController.setCallbackOnchartValueSelected(callback: {
            candleEntryIndex, volumeValue, timeSince1970InSec in
            
            self.barChartViewController.emitCallbackOnchartValueSelected(candleEntryIndex: candleEntryIndex, volumeValue: volumeValue, secondsSince1970: timeSince1970InSec)
            if self.candleShortInfoView.isHidden {
                self.candleShortInfoView.isHidden = false
            }
            self.candleShortInfoView.model = self.candleChartViewController.chartData.candles[candleEntryIndex]
        })
    }
    
    @objc func onLoadCurrencyPairChartDataSuccess(notification: Notification) {
        guard let chartData = notification.userInfo!["data"] as? ExmoChartData else {
            return
        }
        candleChartViewController.chartData = chartData
        barChartViewController.chartData = chartData
    }
    
    @objc func onLoadCurrencyPairChartDataFailed() {
        // show alert
        // output.closeView()
    }
}
