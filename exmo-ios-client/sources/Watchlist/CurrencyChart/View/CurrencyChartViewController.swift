//
//  WatchlistCurrencyChartCurrencyChartViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import Charts

// MARK: ChartTimePeriodContainer
class ChartTimePeriodContainer: UIView {
    enum PeriodType: String {
        case year  = "year"
        case month = "month"
        case week  = "week"
        case day   = "day"
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

    func setupTouchListeners() {
        btnOneYear.addTarget(self, action: #selector(handleTouchOnPeriodBtn(_:)), for: .touchUpInside)
        btnOneMonth.addTarget(self, action: #selector(handleTouchOnPeriodBtn(_:)), for: .touchUpInside)
        btnOneWeek.addTarget(self, action: #selector(handleTouchOnPeriodBtn(_:)), for: .touchUpInside)
        btnOneDay.addTarget(self, action: #selector(handleTouchOnPeriodBtn(_:)), for: .touchUpInside)
    }

    func emitTouch(periodType: PeriodType) {
        switch (periodType) {
        case PeriodType.year : handleTouchOnPeriodBtn(btnOneYear)
        case PeriodType.month: handleTouchOnPeriodBtn(btnOneMonth)
        case PeriodType.week : handleTouchOnPeriodBtn(btnOneWeek)
        case PeriodType.day  : handleTouchOnPeriodBtn(btnOneDay)
        }
    }

    @objc func handleTouchOnPeriodBtn(_ senderBtn: UIButton) {
        btnOneYear.setTitleColor(.white, for: .normal)
        btnOneMonth.setTitleColor(.white, for: .normal)
        btnOneWeek.setTitleColor(.white, for: .normal)
        btnOneDay.setTitleColor(.white, for: .normal)

        senderBtn.setTitleColor(UIColor(red: 118.0/255, green: 184.0/255, blue: 254.0/255, alpha: 1), for: .normal)

        print("senderBtn.x = \(senderBtn.frame.origin.x)")
        indicatorLeadingConstraint.constant = senderBtn.frame.origin.x + 30
        
        switch (senderBtn) {
        case btnOneYear:
            print("touch on year")
            callbackOnChangePeriod?(PeriodType.year.rawValue)
        case btnOneMonth:
            print("touch on month")
            callbackOnChangePeriod?(PeriodType.month.rawValue)
        case btnOneWeek:
            print("touch on week")
            callbackOnChangePeriod?(PeriodType.week.rawValue)
        case btnOneDay:
            print("touch on day")
            callbackOnChangePeriod?(PeriodType.day.rawValue)
        default:
            break
        }

    }
}

// MARK: CurrencyChartViewController
class CurrencyChartViewController: ExmoUIViewController, CurrencyChartViewInput {
    @IBOutlet weak var candleShortInfoView: CandleBarChartShortInfoView!
    @IBOutlet weak var candleChart: CandleStickChartView!
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var periodViewController: ChartTimePeriodContainer!

    var output: CurrencyChartViewOutput!
    private var chartData: ExmoChartData!
    private var candleChartViewController = CandleStickChartViewController()
    private var barChartViewController = BarChartViewController()
    private var currencyPair: String = ""
    
    let addAlertButton = CurrencyChartViewController.getButton(icNamed: "icNavbarAddAlert")
    let addOrderButton = CurrencyChartViewController.getButton(icNamed: "icNavbarAddOrder")

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleNavBar = Utils.getDisplayCurrencyPair(rawCurrencyPairName: currencyPair)
        periodViewController.setupTouchListeners()
        setupInitialState()
        setupBannerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        periodViewController.emitTouch(periodType: .week)
    }

    // MARK: CurrencyChartViewInput
    func setupInitialState() {
        candleShortInfoView.isHidden = true
        navigationController?.navigationBar.tintColor = .white
        
        addAlertButton.addTarget(self, action: #selector(onTouchAddAlertButton(_:)), for: .touchUpInside)
        addOrderButton.addTarget(self, action: #selector(onTouchAddOrderButton(_:)), for: .touchUpInside)
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 15
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: addOrderButton),
            fixedSpace,
            UIBarButtonItem(customView: addAlertButton)]

        prepareCharts()
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
    
    @objc
    func onLoadCurrencyPairChartDataFailed() {
        // show alert
        // output.closeView()
    }
    
    @objc
    func onTouchAddAlertButton(_ senderButton: UIButton) {
        output.onTouchAddAlert(pair: currencyPair)
    }

    @objc
    func onTouchAddOrderButton(_ senderButton: UIButton) {
        output.onTouchAddOrder(pair: currencyPair)
    }
    
    func updateChart(chartData: ExmoChartData?) {
        guard let chartData = chartData else { return }
        
        candleChartViewController.chartData = chartData
        barChartViewController.chartData = chartData
    }
    
    func setCurrencyPair(_ currencyPair: String) {
        self.currencyPair = currencyPair
    }
    
    static private func getButton(icNamed: String) -> UIButton {
        let icon = UIImage(named: icNamed)?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setImage(icon, for: .normal)
        return button
    }
}

extension CurrencyChartViewController {
    func setSubscription(_ package: CHSubscriptionPackageProtocol) {
        print("\(String(describing: self)) => \(#function)")
        super.isAdsActive = package.isAdsPresent
        if package.isAdsPresent {
            showAdsView()
        } else {
            hideAdsView()
        }
    }
}
