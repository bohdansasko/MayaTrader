//
//  CandleStickChartViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts

//
// @MARK: CandleStickChartViewController
//
class CandleStickChartViewController {
    typealias CallbackOnchartValueSelected = (Int, Double, Double) -> Void
    typealias CallbackOnChartTranslated = (CGFloat) -> Void
    
    @IBOutlet weak var chartView: CandleStickChartView!
    
    var chartData: ExmoChartData = ExmoChartData() {
        didSet {
            setupChart()
        }
    }
    
    private var callbackOnchartValueSelected: CallbackOnchartValueSelected? = nil
    private var callbackOnChartTranslated: CallbackOnChartTranslated? = nil
    
    init() {
        // do nothing
    }
    
    private func setupChart() {
        chartView.delegate = self
        
        let candleData = getCandleChartData()
        chartView.data = candleData

        chartView.setVisibleXRangeMaximum(20)
        chartView.setVisibleXRangeMinimum(10)
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
        chartView.dragXEnabled = true
        chartView.doubleTapToZoomEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.candleData?.setDrawValues(false)

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.gridColor = UIColor.clear

        chartView.leftAxis.axisMinimum = chartData.getMinLow()
        chartView.leftAxis.enabled = false
        
        chartView.rightAxis.gridColor = UIColor.dark1
        chartView.rightAxis.labelFont = UIFont.getExo2Font(fontType: .Medium, fontSize: 10)
        chartView.rightAxis.labelTextColor = UIColor.white
        chartView.rightAxis.axisMinimum = chartView.leftAxis.axisMinimum
        chartView.rightAxis.resetCustomAxisMin()
        chartView.rightAxis.xOffset = 1.25
        
        chartView.moveViewToX(Double(chartData.candles.count))
    }
    
    private func getCandleChartData() -> CandleChartData {
        let yVals1 = (0..<self.chartData.candles.count).map { (i) -> CandleChartDataEntry in
            let candleModel = self.chartData.candles[i]
            let open = candleModel.open
            let high = candleModel.high
            let low = candleModel.low
            let close = candleModel.close
            return CandleChartDataEntry(x: Double(i), shadowH: high, shadowL: low, open: open, close: close)
        }
        
        let set1 = CandleChartDataSet(values: yVals1, label: "Data Set")
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
    
    func setCallbackOnchartValueSelected(callback: CallbackOnchartValueSelected?) {
        callbackOnchartValueSelected = callback
    }
    
    func setCallbackOnChartTranslated(callback: CallbackOnChartTranslated?) {
        callbackOnChartTranslated = callback
    }
    
    func validIndex(currentIndex: Int, minIndex: Int, maxIndex: Int) -> Bool {
        let minBorder = minIndex - 1
        let maxBorder = maxIndex + 1
        return currentIndex > minBorder && currentIndex < maxBorder
    }
    
    func emitCallbackOnchartValueSelected(dataEntryIndex: Int, volumeValue: Double, secondsSince1970: Double) {

        callbackOnchartValueSelected?(dataEntryIndex, volumeValue, secondsSince1970)
    }
    
    func moveChartByXTo(index: Double) {
        print(index)
        chartView.moveViewToAnimated(xValue: index, yValue: 0, axis: .right, duration: 0.5)
    }
}

//
// @MARK: Delegate
//
extension CandleStickChartViewController : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let candleEntry = entry as? CandleChartDataEntry else {
            return
        }
        let dataIndex = Int(candleEntry.x)
        if !validIndex(currentIndex: dataIndex, minIndex: 0, maxIndex: chartData.candles.count - 1) {
            return
        }
        
        callbackOnchartValueSelected?(dataIndex, chartData.candles[dataIndex].volume, chartData.candles[dataIndex].timeSince1970InSec)
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        print("candle dx\(chartView.viewPortHandler.transX)")
         callbackOnChartTranslated?(chartView.viewPortHandler.transX)
    }
}
