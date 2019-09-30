//
//  CHCandleChartPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts

final class CHCandleChartPresenter: CHBaseChartPresenter {
    fileprivate(set) weak var chartView: CandleStickChartView!
    
    var candles: [CHCandleModel] = [] {
        didSet {
            setupChartUI()
        }
    }
    
    init(chartView: CandleStickChartView!) {
        assert(chartView != nil, "required not nil")
        
        self.chartView = chartView
        super.init()
    }
    
    override func moveChartByXTo(index: Double) {
        chartView.moveViewToX(index)
    }
    
}

// MARK: - Setup methods

private extension CHCandleChartPresenter {
    
    func setupChartUI() {
        if candles.isEmpty {
            return
        }
        
        chartView.delegate = self
        
        let candleData = getCandleChartData()
        chartView.data = candleData

        chartView.setVisibleXRangeMaximum(20)
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
        chartView.dragXEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.candleData?.setDrawValues(false)

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.gridColor = UIColor.clear
        chartView.xAxis.valueFormatter = self
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelTextColor = .white

        let minLowCandle = candles.min(by: { $0.low < $1.low })?.low ?? 0.0
        chartView.leftAxis.axisMinimum = minLowCandle
        chartView.leftAxis.enabled = false
        
        chartView.rightAxis.gridColor = UIColor.dark1
        chartView.rightAxis.labelFont = UIFont.getExo2Font(fontType: .medium, fontSize: 10)
        chartView.rightAxis.labelTextColor = UIColor.white
        chartView.rightAxis.axisMinimum = chartView.leftAxis.axisMinimum
        chartView.rightAxis.resetCustomAxisMin()
        chartView.rightAxis.xOffset = 1.25
        
        chartView.moveViewToX(Double(candles.count))
    }
    
}

// MARK: -

private extension CHCandleChartPresenter {
    
    func getCandleChartData() -> CandleChartData {
        if candles.isEmpty {
            return CandleChartData(dataSet: nil)
        }
        
        let yVals1 = (0..<candles.count).map { (idx) -> CandleChartDataEntry in
            let candleModel = candles[idx]
            let open = candleModel.open
            let high = candleModel.high
            let low = candleModel.low
            let close = candleModel.close
            return CandleChartDataEntry(x: Double(idx), shadowH: high, shadowL: low, open: open, close: close)
        }
        
        let set1 = CandleChartDataSet(entries: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = UIColor(red: 255/255, green: 105/255, blue: 96/255, alpha: 1)
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 0/255, green: 189/255, blue: 154/255, alpha: 1)
        set1.increasingFilled = true
        set1.neutralColor = .blue
        set1.barSpace = 0.1
        set1.shadowColorSameAsCandle = true
        set1.valueTextColor = UIColor.white
        
        return CandleChartData(dataSet: set1)
    }
    
}

// MARK: - IAxisValueFormatter

extension CHCandleChartPresenter : IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let candleItem = self.candles[Int(value)]
        
        let dt = DateFormatter()
        dt.dateFormat = "MM/dd"
        let formatedDate = dt.string(from: Date(timeIntervalSince1970: candleItem.timestamp))
        
        return formatedDate
    }
    
}

// MARK: - ChartViewDelegate

extension CHCandleChartPresenter : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        callbackOnchartValueSelected?(highlight)
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        log.debug("candle dx\(dX)")
        guard let highlight = self.chartView.getHighlightByTouchPoint(CGPoint(x: dX, y: dY)) else { return }
        callbackOnChartTranslated?(highlight)
    }
    
}
