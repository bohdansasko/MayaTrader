//
//  CHChartPeriodsView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 9/26/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol CHChartPeriodViewDelegate: class {
    func chartPeriodView(_ periodView: CHChartPeriodsView, didSelect period: CHPeriod)
}

final class CHChartPeriodsView: UIView {
    
    // MARK: - Private outlets
    
    @IBOutlet fileprivate weak var buttonsSV    : UIStackView!
    @IBOutlet fileprivate weak var indicatorView: UIView!
    
    // MARK: - Private variables
    
    fileprivate(set) var items: [CHPeriod] = []
    fileprivate(set) var selectedItem: CHPeriod = .day
    
    // MARK: - Public variables
    
    weak var delegate: CHChartPeriodViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if items.isEmpty { return }
        
        let selectedItemIdx   = items.index(of: selectedItem)!
        let newSelectedButton = buttonsSV.arrangedSubviews[selectedItemIdx] as! UIButton
        updateIndicatorPosition(selectedButton: newSelectedButton)
    }
    
}

// MARK: - Setters

extension CHChartPeriodsView {
    
    func set(_ items: [CHPeriod]) {
        self.items = items
        buttonsSV.removeAllArrangedSubviews()
        
        self.items.forEach { (p: CHPeriod) in
            let b = makeButton(with: p)
            b.isSelected = p == selectedItem
            b.snp.makeConstraints{ $0.width.equalTo(20) }
            b.addTarget(self, action: #selector(actTapOnButton(_:)), for: .touchUpInside)
            buttonsSV.addArrangedSubview(b)
        }
        
    }

    func set(selected item: CHPeriod) {
        updateHighlightedPeriod(prev: selectedItem, current: item)
        selectedItem = item
    }
    
}

// MARK: - User interactions

private extension CHChartPeriodsView {
    
    @objc func actTapOnButton(_ senderButton: UIButton) {
        let idx = buttonsSV.arrangedSubviews.index(of: senderButton)!
        let tappedPeriod = items[idx]
        delegate?.chartPeriodView(self, didSelect: tappedPeriod)
    }
    
}

// MARK: - Makers

private extension CHChartPeriodsView {

    func makeButton(with p: CHPeriod, normalTextColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), selectedTextColor: UIColor = #colorLiteral(red: 0.240691781, green: 0.7259395123, blue: 1, alpha: 1)) -> UIButton {
        let button = UIButton()
        button.setTitle(p.title, for: .normal)
        button.setTitleColor(normalTextColor, for: .normal)
        button.setTitleColor(selectedTextColor, for: .highlighted)
        button.setTitleColor(selectedTextColor, for: .selected)
        button.titleLabel?.font = UIFont.getExo2Font(fontType: .medium, fontSize: 14)
        return button
    }
    
}

// MARK: - Update views

private extension CHChartPeriodsView {

    func updateHighlightedPeriod(prev: CHPeriod, current: CHPeriod) {
        assert(!items.isEmpty, "required")
        
        let prevSelectedItemIdx = items.index(of: prev)!
        let newSelectedItemIdx  = items.index(of: current)!
        
        let prevSelectedButton = buttonsSV.arrangedSubviews[prevSelectedItemIdx] as! UIButton
        let newSelectedButton  = buttonsSV.arrangedSubviews[newSelectedItemIdx] as! UIButton
        
        prevSelectedButton.isSelected = false
        newSelectedButton.isSelected  = true
        
        updateIndicatorPosition(selectedButton: newSelectedButton)
    }
   
    func updateIndicatorPosition(selectedButton: UIButton) {
        UIView.animate(withDuration: 0.2,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: {
                            self.indicatorView.frame.origin.x = selectedButton.frame.origin.x + 30
                       },
                       completion: nil)
    }
    
}
