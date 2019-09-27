//
//  CHBaseChartPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/27/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Charts

class CHBaseChartPresenter {
    
    typealias CallbackOnchartValueSelected = (Highlight) -> Void
    typealias CallbackOnChartTranslated = (Highlight) -> Void
    
    var callbackOnchartValueSelected: CallbackOnchartValueSelected?
    var callbackOnChartTranslated: CallbackOnChartTranslated?
    
    func setupChart() {
        fatalError("moveChartByXTo doesn't have implementation")
    }
    
    func setCallbackOnChartValueSelected(callback: CallbackOnchartValueSelected?) {
        callbackOnchartValueSelected = callback
    }
    
    func setCallbackOnChartTranslated(callback: CallbackOnChartTranslated?) {
        callbackOnChartTranslated = callback
    }
    
    func emitCallbackOnchartValueSelected(highlight: Highlight) {
        callbackOnchartValueSelected?(highlight)
    }
    
    func moveChartByXTo(index: Double) {
        fatalError("moveChartByXTo doesn't have implementation")
    }
    
}
