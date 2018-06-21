//
//  WatchlistCurrencyChartWatchlistCurrencyChartViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 06/06/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import Charts

class WatchlistCurrencyChartViewController: ExmoUIViewController, WatchlistCurrencyChartViewInput {

    @IBOutlet weak var candleChartView: CandleStickChartView!
    @IBOutlet weak var lineChartView: LineChartView!
    
    var output: WatchlistCurrencyChartViewOutput!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState();
    }
    
    // MARK: WatchlistCurrencyChartViewInput
    func setupInitialState() {
        prepareCandleBar()
        prepareLineBar()
    }
    
    private func prepareLineBar() {
        let values: [Double] = [8, 104, 81, 93, 52, 44, 97, 101, 75, 28,
                                76, 25, 20, 13, 52, 44, 57, 23, 45, 91,
                                99, 14, 84, 48, 40, 71, 106, 41, 45, 61]
        
        var entries: [ChartDataEntry] = Array()
        
        for (i, value) in values.enumerated() {
            entries.append(ChartDataEntry(x: Double(i), y: value))
        }
        
        let dataSet = LineChartDataSet(values: entries, label: nil)
        dataSet.drawIconsEnabled = false
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        
        let lineChartData = LineChartData(dataSet: dataSet)
        self.lineChartView.data = lineChartData
        
        self.lineChartView.backgroundColor = UIColor.clear
        self.lineChartView.leftAxis.axisMinimum = 0.0
        self.lineChartView.rightAxis.axisMinimum = 0.0
        self.lineChartView.minOffset = 0
        self.lineChartView.legend.enabled = false
        self.lineChartView.leftAxis.enabled = false
        self.lineChartView.dragXEnabled = true
        self.lineChartView.maxVisibleCount = 20
        self.lineChartView.zoom(scaleX: 2.0, scaleY: 1, x: 0, y: 0)
        self.lineChartView.moveViewToX(Double(entries.count))
    }
    
    private func prepareCandleBar() {
        let dataPoints = [[1528329601000,7602.3,7690,7593.8,7666.68],[1528344001000,7667.45,7680,7638.80000501,7679.26995966],[1528358401000,7678,7680,7627.1805478,7650],[1528372801000,7650,7670,7607.1,7636.93],[1528387201000,7636,7800,7630,7658],[1528401601000,7657.00078,7659.9,7609.87186074,7628.9198961],[1528416001000,7658,7680.687328,7620,7620.1],[1528430401000,7620.1,7646.29999859,7615,7615],[1528444801000,7615,7639.89999999,7552.49857164,7568],[1528459201000,7568,7656,7550,7656],[1528473601000,7630.60000002,7670.74899666,7630.60000002,7656.8],[1528488001000,7656,7668.99999999,7637.69123249,7641.53],[1528502401000,7637.6912325,7679.25664152,7630.81,7649.83095799],[1528516801000,7652.83,7660.99999999,7625.00000001,7651.79999],[1528531201000,7651.69999,7655.77193437,7611.84161677,7635.7],[1528545601000,7643.89958891,7643.89958891,7580,7605.00000011],[1528560001000,7630,7630.12,7585.00000001,7618.99999999],[1528574401000,7615.99999999,7619.89999999,7500,7515.04192908],[1528588801000,7518.85022796,7520.120089,7339,7356],[1528603201000,7350.7,7400,7261,7267.2],[1528617601000,7267.2,7347.449999,7245,7274.5],[1528632001000,7285.2,7320.6,7235,7280.7],[1528646401000,7282.9,7335.43,6850,7016.83507517],[1528660801000,7039.3,7047.16699181,6840,6885.94586521],[1528675201000,6885.94,6948.34269299,6833,6920.24],[1528689601000,6936.12604425,6969.54201841,6824.82595208,6824.82595208],[1528704001000,6815,6948.33999999,6809.7,6911],[1528718401000,6911,6911,6810,6820.00013001],[1528732801000,6829.999999,6889.99999999,6800,6851.52330801],[1528747201000,6866.86,6995,6850,6976.16245303],[1528761601000,6982,6983.61182549,6892.01539647,6926.6],[1528776001000,6929.09999988,6960.83996668,6900.10000001,6915.1],[1528790401000,6930.292421,6951.65999999,6895.89089746,6926.3],[1528804801000,6935,6945.78128,6802,6849.02],[1528819201000,6846.5,6859.1299919,6577.43737682,6649],[1528833601000,6643.44356,6719.57748,6613.1342,6704.1],[1528848001000,6683.2427,6719.57748068,6672.57815722,6681.9],[1528862401000,6680.10000001,6719.57748068,6655.27590213,6656.88888888],[1528876801000,6681.40879085,6693.28827155,6500,6601],[1528891201000,6607.33,6626.18,6520,6521],[1528905601000,6521.00000001,6557.22866278,6310,6427.8],[1528920001000,6425.032128,6446.49377275,6371.63610427,6423.40200403],[1528934401000,6423.40200403,6595.65653089,6368.629929,6576.21]];
        
        candleChartView.dragXEnabled = true
        candleChartView.maxVisibleCount = 20
        candleChartView.pinchZoomEnabled = true
        
        self.setCandleChart(dataPoints: dataPoints, values: [])
        
        self.candleChartView.minOffset = 0
        self.candleChartView.legend.enabled = false
        self.candleChartView.leftAxis.enabled = false
    }
    

    private func setCandleChart(dataPoints: [[Double]], values: [Double]) {
        let yVals1 = (0..<dataPoints.count).map { (i) -> CandleChartDataEntry in
            let open = dataPoints[i][1]
            let high = dataPoints[i][2]
            let low = dataPoints[i][3]
            let close = dataPoints[i][4]
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
        set1.shadowColorSameAsCandle = true
        set1.valueTextColor = UIColor.white

        let chartData = CandleChartData(dataSet: set1)
        self.candleChartView.data = chartData
        chartData.setValueTextColor(UIColor.white)
        
        self.candleChartView.zoom(scaleX: 2.0, scaleY: 1, x: 0, y: 0)
        self.candleChartView.moveViewToX(Double(yVals1.count))
    }
}
