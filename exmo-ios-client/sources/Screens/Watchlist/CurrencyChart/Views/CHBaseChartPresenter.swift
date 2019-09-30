//
//  CHBaseChartPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/27/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Charts

protocol CHBaseChartPresenterDelegate: class {
    func chartPresenter(_ presenter: CHBaseChartPresenter, didSelectChartValue value: Highlight)
    func chartPresenter(_ presenter: CHBaseChartPresenter, didTranslateChartValue value: Highlight)
}

class CHBaseChartPresenter {
    
    weak var delegate: CHBaseChartPresenterDelegate?
    
    func moveChartByXTo(index: Double) {
        fatalError("moveChartByXTo doesn't have implementation")
    }
    
}
