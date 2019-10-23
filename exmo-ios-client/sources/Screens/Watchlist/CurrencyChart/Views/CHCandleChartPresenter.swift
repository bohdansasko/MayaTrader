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
    fileprivate(set) var chartView: CandleStickChartView!
    
    private var candles: [CHCandleModel] = [] {
        didSet {
            updateChartView()
        }
    }
    
    init(chartView: CandleStickChartView!) {
        assert(chartView != nil, "required not nil")
        
        self.chartView = chartView
        
        super.init()
        
        self.chartView.delegate = self
        self.setupChartView()
    }
    
    override func moveChartByXTo(index: Double) {
        chartView.moveViewToX(index)
    }
    
}

// MARK: - Setup methods

private extension CHCandleChartPresenter {
    
    func setupChartView() {
        let entries = makeCandleChartDataEntries(from: candles)
        let candleData = makeCandleChartData(from: entries)
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
        
        chartView.rightAxis.gridColor = UIColor.dark1
        chartView.rightAxis.labelFont = UIFont.getExo2Font(fontType: .medium, fontSize: 10)
        chartView.rightAxis.labelTextColor = UIColor.white
    }
    
    func updateChartView() {
//        let minLowCandle = candles.min(by: { $0.low < $1.low })!.low
//
//        chartView.leftAxis.axisMinimum = minLowCandle
//        chartView.rightAxis.axisMinimum = chartView.leftAxis.axisMinimum
//        
//        chartView.rightAxis.resetCustomAxisMin()
//        chartView.rightAxis.xOffset = 1.25
//        chartView.moveViewToX(Double(candles.count))
    }
    
}

// MARK: - 

extension CHCandleChartPresenter {
    
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

// MARK: -

private extension CHCandleChartPresenter {
    
    func makeCandleChartDataEntries(from candles: [CHCandleModel]) -> [CandleChartDataEntry] {
        return candles.enumerated().map { (idx, candleModel) -> CandleChartDataEntry in
            let open = candleModel.open
            let high = candleModel.high
            let low = candleModel.low
            let close = candleModel.close
            return CandleChartDataEntry(x: Double(idx), shadowH: high, shadowL: low, open: open, close: close)
        }
    }
    
    func makeCandleChartData(from entries: [CandleChartDataEntry]?) -> CandleChartData {
        let dataSet = CandleChartDataSet(entries: entries, label: "Data Set")
        dataSet.axisDependency   = .left
        dataSet.setColor(#colorLiteral(red: 0.3135, green: 0.3135, blue: 0.3135, alpha: 1))
        dataSet.drawIconsEnabled = false
        dataSet.shadowColor      = .darkGray
        dataSet.shadowWidth      = 0.7
        dataSet.decreasingColor  = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.3764705882, alpha: 1)
        dataSet.decreasingFilled = true
        dataSet.increasingColor  = #colorLiteral(red: 0, green: 0.7411764706, blue: 0.6039215686, alpha: 1)
        dataSet.increasingFilled = true
        dataSet.neutralColor     = .blue
        dataSet.barSpace         = 0.1
        dataSet.shadowColorSameAsCandle = true
        dataSet.valueTextColor   = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return CandleChartData(dataSet: dataSet)
    }
    
}

// MARK: - IAxisValueFormatter

extension CHCandleChartPresenter : IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let approxX = Int(value)
        if approxX > self.candles.count {
            //assertionFailure("fix me")
            return ""
        }

        let candleItem = self.candles[approxX]
        
        let dt = DateFormatter()
        dt.dateFormat = "MM/dd"
        let formattedDate = dt.string(from: Date(timeIntervalSince1970: candleItem.timestamp))
        
        return formattedDate
    }
    
}

// MARK: - ChartViewDelegate

extension CHCandleChartPresenter: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        delegate?.chartPresenter(self, didSelectChartValue: highlight)
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        guard let highlight = self.chartView.getHighlightByTouchPoint(CGPoint(x: dX, y: dY)) else { return }
        delegate?.chartPresenter(self, didTranslateChartValue: highlight)
    }
    
}
