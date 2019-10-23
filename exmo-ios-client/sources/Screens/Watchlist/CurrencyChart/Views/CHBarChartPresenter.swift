//
//  CHBarChartPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts

final class CHBarChartPresenter: CHBaseChartPresenter {
    fileprivate(set) weak var chartView: BarChartView!
    
    fileprivate var candles: [CHCandleModel] = [] {
        didSet {
            setupChartUI()
        }
    }
    
    init(chartView: BarChartView!) {
        assert(chartView != nil, "required not nil")
        
        self.chartView = chartView
        
        super.init()
        
        self.chartView.delegate = self
    }
    
    override func moveChartByXTo(index: Double) {
        chartView.moveViewToX(index)
    }
    
}

// MARK: - Setup

private extension CHBarChartPresenter {
    
    func setupChartUI() {
        if candles.isEmpty {
            return
        }
        
        let lineData = getBarChartData()
        chartView.data = lineData
        chartView.delegate = self
        chartView.fitBars = true
        
        let minVolumeCandle = candles.min(by: { $0.volume < $1.volume })?.volume ?? 0.0
        chartView.leftAxis.axisMinimum = minVolumeCandle
        
        chartView.rightAxis.axisMinimum = chartView.leftAxis.axisMinimum
        chartView.rightAxis.resetCustomAxisMin()
        
        chartView.backgroundColor = UIColor.clear
        chartView.legend.enabled = false
        chartView.leftAxis.enabled = false
        chartView.dragXEnabled = true
        chartView.setVisibleXRange(minXRange: 1, maxXRange: 20)
        chartView.barData?.barWidth = 0.9
        
        chartView.xAxis.axisLineColor = UIColor.clear
        chartView.xAxis.gridColor = UIColor.clear
        chartView.rightAxis.zeroLineColor = UIColor.clear
        chartView.rightAxis.gridColor = UIColor.clear
        chartView.rightAxis.labelFont = UIFont.getExo2Font(fontType: .medium, fontSize: 10)
        chartView.rightAxis.labelTextColor = UIColor.white
        chartView.chartDescription?.enabled = false
        
        chartView.moveViewToX(Double(candles.count))
    }
    
}

// MARK: -

extension CHBarChartPresenter {
    
    func set(candles items: [CHCandleModel]) {
        self.candles = items
    }
    
    func append(candles items: [CHCandleModel]) {
        self.candles.insert(contentsOf: items, at: 0)
    }
    
    func candle(at index: Int) -> CHCandleModel {
        return self.candles[index]
    }
    
}

// MARK: - Getters

private extension CHBarChartPresenter {
    
    func getBarChartData() -> BarChartData {
        
        var entries: [BarChartDataEntry] = Array()
        
        for (index, value) in candles.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index), y: value.volume))
        }
        
        let dataSet = BarChartDataSet(entries: entries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.setColor(UIColor.steel)
        dataSet.drawIconsEnabled = false
        
        let barChartData = BarChartData(dataSet: dataSet)
        barChartData.barWidth = 0.1
        
        return barChartData
    }
    
}

// MARK: - ChartViewDelegate

extension CHBarChartPresenter: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        delegate?.chartPresenter(self, didSelectChartValue: highlight)
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        guard let highlight = self.chartView.getHighlightByTouchPoint(CGPoint(x: dX, y: dY)) else { return }
        delegate?.chartPresenter(self, didTranslateChartValue: highlight)
    }
    
}
