//
//  CHOrdersView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHOrdersView: CHBaseTabView {
    @IBOutlet private      weak var ordersCategoriesControl: UISegmentedControl!
    @IBOutlet private(set) weak var ordersListView         : UITableView!
        
    var selectedOrdersTab: OrdersType {
        return OrdersType(rawValue: ordersCategoriesControl.selectedSegmentIndex)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func setTutorialVisible(isUserAuthorizedToExmo: Bool, hasContent: Bool) {
        if isUserAuthorizedToExmo {
            let text = getStubText(by: selectedOrdersTab)
            stubState = hasContent ? .none : .noContent(#imageLiteral(resourceName: "imgTutorialOrder"), text)
        } else {
            stubState = .notAuthorized(nil, nil)
        }
    }
    
    private func getStubText(by orderType: OrdersType) -> String {
        switch orderType {
        case .open:
            return "SCREEN_ORDERS_OPENED".localized
        case .cancelled:
            return "SCREEN_ORDERS_CANCELED".localized
        case .deals:
            return "SCREEN_ORDERS_DEALS".localized
        }
    }
    
}

// MARK: - Setup

private extension CHOrdersView {
    
    func setupUI() {
        setupSegmentControl()
    }
    
    func setupSegmentControl() {
        ordersCategoriesControl.removeAllSegments()
        
        ordersCategoriesControl.setTitleTextAttributes(
            [
              .font           : UIFont.getExo2Font(fontType: .regular, fontSize: 13),
              .foregroundColor: UIColor.white
            ],
            for: .normal
        )
        
        ordersCategoriesControl.setTitleTextAttributes(
            [
                .font           : UIFont.getExo2Font(fontType: .regular, fontSize: 13),
                .foregroundColor: UIColor.black
            ],
            for: .selected
        )
        
        let segmentsTitles = [
            "ORDERS_OPEN".localized,
            "ORDERS_CANCELLED".localized,
            "ORDERS_DEALS".localized
        ]
        segmentsTitles.enumerated().forEach{ [unowned self] (idx, title) in
            self.ordersCategoriesControl.insertSegment(withTitle: title, at: idx, animated: false)
        }
        ordersCategoriesControl.selectedSegmentIndex = 0
    }
    
}

// MARK: - Setters

extension CHOrdersView {
    
    func set(target: Any?, actionOnSelectTab action: Selector) {
        ordersCategoriesControl.addTarget(target, action: action, for: .valueChanged)
    }
    
}

// MARK: - Actions

extension CHOrdersView {
    
    func select(tab: OrdersType) {
        ordersCategoriesControl.selectedSegmentIndex = tab.rawValue
        ordersCategoriesControl.sendActions(for: .valueChanged)
    }
    
}
