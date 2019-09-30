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
    
    @IBOutlet fileprivate weak var candleDetailsContainer: UIView!
              fileprivate(set) var candleDetailsView     : CHCandleDetailsView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPeriodsView()
        setupCandleDetailsView()
    }
    
}

// MARK: - Setup

private extension CHCurrencyChartView {
    
    func setupPeriodsView() {
        periodsView = CHChartPeriodsView.loadViewFromNib()
        periodsContainer.addSubview(periodsView)
        periodsView.snp.makeConstraints{ $0.edges.equalToSuperview() }
        
        let items: [CHPeriod] = [ .year, .month, .week, .day ]
        periodsView.set(items)

        periodsView.setNeedsLayout()
        periodsView.layoutIfNeeded()
    }
    
    func setupCandleDetailsView() {
        candleDetailsView = CHCandleDetailsView.loadViewFromNib()
        candleDetailsContainer.addSubview(candleDetailsView)
        candleDetailsView.snp.makeConstraints{ $0.edges.equalToSuperview() }

        candleDetailsView.isHidden = true
        
        candleDetailsView.setNeedsLayout()
        candleDetailsView.layoutIfNeeded()
    }
    
}

// MARK: - Set

extension CHCurrencyChartView {
    
    func set(selectedPeriod period: CHPeriod) {
        periodsView.set(selected: period)
    }
    
    func set(periodsDelegate delegate: CHChartPeriodViewDelegate) {
        periodsView.delegate = delegate
    }
    
    func set(candleDetails candle: CHCandleModel?) {
        guard let candle = candle else {
            candleDetailsView.isHidden = true
            return
        }
        log.debug(candle)
        candleDetailsView.isHidden = false
        
        let formatter = CHCandleDetailsFormatter(item: candle)
        candleDetailsView.set(formatter: formatter)
    }
    
}
