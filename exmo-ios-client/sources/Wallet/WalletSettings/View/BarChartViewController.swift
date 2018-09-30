//
//  BarChartViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/26/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts

//
// @MARK: BarChartViewController
//
class BarChartViewController {
    typealias CallbackOnchartValueSelected = (Int, Double, Double) -> Void
    typealias CallbackOnChartTranslated = (CGFloat) -> Void
    
    @IBOutlet weak var chartView: BarChartView!
    
    var chartData: ExmoChartData = ExmoChartData() {
        didSet {
            setupChart()
        }
    }
    
    private var callbackOnchartValueSelected: CallbackOnchartValueSelected? = nil
    private var callbackOnChartTranslated: CallbackOnChartTranslated? = nil
    
    private func setupChart() {
        let lineData = getBarChartData()
        chartView.data = lineData
        chartView.delegate = self
        chartView.fitBars = true
        chartView.leftAxis.axisMinimum = chartData.getMinVolume()
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
        chartView.rightAxis.labelFont = UIFont.getExo2Font(fontType: .Medium, fontSize: 10)
        chartView.rightAxis.labelTextColor = UIColor.white
        chartView.chartDescription?.enabled = false
        
        chartView.moveViewToX(Double(chartData.candles.count))
    }
    
    private func getBarChartData() -> BarChartData {
        
        var entries: [BarChartDataEntry] = Array()
        
        for (index, value) in chartData.candles.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index), y: value.volume))
        }
        
        let dataSet = BarChartDataSet(values: entries, label: "")
        dataSet.drawValuesEnabled = false
        dataSet.setColor(UIColor.steel)
        dataSet.drawIconsEnabled = false
        
        let barChartData = BarChartData(dataSet: dataSet)
        barChartData.barWidth = 0.1
        
        return barChartData
    }
    
    func setCallbackOnChartValueSelected(callback: CallbackOnchartValueSelected?) {
        callbackOnchartValueSelected = callback
    }
    
    func setCallbackOnChartTranslated(callback: CallbackOnChartTranslated?) {
        callbackOnChartTranslated = callback
    }
    
    func moveChartByXTo(index: Double) {
        chartView.moveViewToAnimated(xValue: index, yValue: 0, axis: .left, duration: 0.5)
    }
    
    func emitCallbackOnchartValueSelected(candleEntryIndex: Int, volumeValue: Double, secondsSince1970: Double) {
        callbackOnchartValueSelected?(candleEntryIndex, volumeValue, secondsSince1970)
    }
    
    func validIndex(currentIndex: Int, minIndex: Int, maxIndex: Int) -> Bool {
        let minBorder = minIndex - 1
        let maxBorder = maxIndex + 1
        return currentIndex > minBorder && currentIndex < maxBorder
    }
}

extension BarChartViewController : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let candleEntry = entry as? BarChartDataEntry else {
            return
        }
        let dataIndex = Int(candleEntry.x)
        if !validIndex(currentIndex: dataIndex, minIndex: 0, maxIndex: chartData.candles.count - 1) {
            return
        }
        
        callbackOnchartValueSelected?(dataIndex, chartData.candles[dataIndex].volume, chartData.candles[dataIndex].timeSince1970InSec/1000)
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        print("bar dx\(chartView.viewPortHandler.transX)")
        
        callbackOnChartTranslated?(chartView.viewPortHandler.transX)
    }
}
