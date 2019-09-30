//
//  CHCurrencyChartView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/25/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import Charts

final class CHCurrencyChartView: UIView {

    @IBOutlet fileprivate weak var periodsContainer: UIView!
              fileprivate(set) var periodsView     : CHChartPeriodsView!
    
    @IBOutlet fileprivate(set) weak var candleChartView: CandleStickChartView!
    @IBOutlet fileprivate(set) weak var barChartView   : BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPeriodsView()
    }
    
}

// MARK: - Setup

extension CHCurrencyChartView {
    
    func setupPeriodsView() {
        periodsView = CHChartPeriodsView.loadViewFromNib()
        periodsView.delegate = self
        periodsContainer.addSubview(periodsView)
        periodsView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        let items: [CHPeriod] = [ .year, .month, .week, .day ]
        periodsView.set(items)
        periodsView.set(selected: .week)
        
        periodsView.setNeedsLayout()
        periodsView.layoutIfNeeded()
    }
    
}

extension CHCurrencyChartView: CHChartPeriodViewDelegate {
    
    func chartPeriodView(_ periodView: CHChartPeriodsView, didSelect period: CHPeriod) {
        periodView.set(selected: period)
    }
    
}
