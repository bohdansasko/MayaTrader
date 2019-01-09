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
// @MARK: ChartTimePeriodContainer
//
class ChartTimePeriodContainer: UIView {
    enum PeriodType: String {
        case Year = "year"
        case Month = "month"
        case Week = "week"
        case Day = "day"
    }
    
    @IBOutlet weak var currentPeriodViewIndicator: UIView!
    @IBOutlet weak var btnOneYear: UIButton!
    @IBOutlet weak var btnOneMonth: UIButton!
    @IBOutlet weak var btnOneWeek: UIButton!
    @IBOutlet weak var btnOneDay: UIButton!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    
    var callbackOnChangePeriod: ((String) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func viewDidLoad() {
        btnOneYear.addTarget(self, action: #selector(handleTouchOnPeriodBtn), for: .touchUpInside)
        btnOneMonth.addTarget(self, action: #selector(handleTouchOnPeriodBtn), for: .touchUpInside)
        btnOneWeek.addTarget(self, action: #selector(handleTouchOnPeriodBtn), for: .touchUpInside)
        btnOneDay.addTarget(self, action: #selector(handleTouchOnPeriodBtn), for: .touchUpInside)
    }

    func emitTouch(periodType: PeriodType) {
        switch (periodType) {
        case PeriodType.Year:
            handleTouchOnPeriodBtn(btnOneYear)
        case PeriodType.Month:
            handleTouchOnPeriodBtn(btnOneMonth)
        case PeriodType.Week:
            handleTouchOnPeriodBtn(btnOneWeek)
        case PeriodType.Day:
            handleTouchOnPeriodBtn(btnOneDay)
        }
    }
    
    @objc func handleTouchOnPeriodBtn(_ sender: Any?) {
        guard let senderBtn = sender as? UIButton else { return }
        
        switch (senderBtn) {
        case btnOneYear:
            print("touch on year")
            indicatorLeadingConstraint.constant = btnOneYear.frame.origin.x + 30
            callbackOnChangePeriod?(PeriodType.Year.rawValue)
        case btnOneMonth:
            print("touch on month")
            indicatorLeadingConstraint.constant = btnOneMonth.frame.origin.x + 30
            callbackOnChangePeriod?(PeriodType.Month.rawValue)
        case btnOneWeek:
            print("touch on week")
            indicatorLeadingConstraint.constant = btnOneWeek.frame.origin.x + 30
            callbackOnChangePeriod?(PeriodType.Week.rawValue)
        case btnOneDay:
            print("touch on day")
            indicatorLeadingConstraint.constant = btnOneDay.frame.origin.x + 30
            callbackOnChangePeriod?(PeriodType.Day.rawValue)
        default:
            break
        }
        
    }
}

//
// @MARK: WatchlistCurrencyChartViewController
//
class WatchlistCurrencyChartViewController: ExmoUIViewController, WatchlistCurrencyChartViewInput {
    @IBOutlet weak var candleShortInfoView: CandleBarChartShortInfoView!
    @IBOutlet weak var candleChart: CandleStickChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var periodViewController: ChartTimePeriodContainer!
    
    var output: WatchlistCurrencyChartViewOutput!
    private var chartData: ExmoChartData!
    private var candleChartViewController = CandleStickChartViewController()
    private var barChartViewController = BarChartViewController()
    private var currencyPair: String = ""
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavBar = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currencyPair)
        output.viewIsReady()
        periodViewController.viewDidLoad()
        setupInitialState()
    }
    
    // MARK: WatchlistCurrencyChartViewInput
    func setupInitialState() {
        candleShortInfoView.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        
        prepareCharts()
        periodViewController.emitTouch(periodType: .Week)
    }
    
    private func prepareCharts() {
        // prepare bar chart
        barChartViewController.chartView = barChart
        barChartViewController.setCallbackOnChartTranslated(callback: {
            highlight in
            self.candleChartViewController.moveChartByXTo(index: highlight.x)
        })
        barChartViewController.setCallbackOnChartValueSelected(callback: {
            highlight in
            self.candleChartViewController.chartView?.highlightValue(highlight)
            self.showCandleInfo(candleIndex: Int(highlight.x))
        })
        
        // prepare candle chart
        candleChartViewController.chartView = candleChart
        candleChartViewController.setCallbackOnChartTranslated(callback: {
            highlight in
            self.barChartViewController.moveChartByXTo(index: highlight.x)
        })
        candleChartViewController.setCallbackOnChartValueSelected(callback: {
            highlight in
            self.barChartViewController.chartView?.highlightValue(highlight)
            self.showCandleInfo(candleIndex: Int(highlight.x))
        })

        periodViewController.callbackOnChangePeriod = {
            [weak self] periodAsString in
            guard let strongSelf = self else { return }
            strongSelf.output.loadChartData(currencyPair: strongSelf.currencyPair, period: periodAsString)
        }
    }
    
    func showCandleInfo(candleIndex: Int) {
        if self.candleShortInfoView.isHidden {
            self.candleShortInfoView.isHidden = false
        }
        self.candleShortInfoView.model = self.candleChartViewController.chartData.candles[candleIndex]
    }
    
    @objc func onLoadCurrencyPairChartDataFailed() {
        // show alert
        // output.closeView()
    }
    
    func updateChart(chartData: ExmoChartData?) {
        guard let chartData = chartData else { return }
        
        candleChartViewController.chartData = chartData
        barChartViewController.chartData = chartData
    }
    
    func setCurrencyPair(_ currencyPair: String) {
        self.currencyPair = currencyPair
    }
}
