//
//  Cells.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/30/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

protocol CurrencyDetailsFormConformity {
    var formItem: CurrencyDetailsItem? {get set}
}

protocol TextFormConformity {
    var formItem: TextFormItem? {get set}
}

protocol FloatingNumberFormConformity {
    var formItem: FloatingNumberFormItem? {get set}
}

protocol SwitchFormConformity {
    var formItem: SwitchFormItem? {get set}
}

protocol SegmentFormConformity {
    var formItem: SegmentFormItem? {get set}
}

protocol FormUpdatable {
    func update(item: FormItem?)
}


enum FormItemCellType {
    case textField
    case floatingNumberTextField
    case switcher
    case segment
    case currencyDetails
    case button
    
    static func registerCells(for tableView: UITableView) {
        let classes = [
            CHTextInputCell.self,
            CHNumberCell.self,
            ExmoSwitchCell.self,
            ExmoSegmentCell.self,
            CHSelectCurrencyCell.self,
            CHButtonCell.self
        ]
        
        classes.forEach({ tableView.register(class: $0) })
    }
    
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch self {
        case .textField:
            return tableView.dequeue(class: CHTextInputCell.self, for: indexPath)
        case .floatingNumberTextField:
            return tableView.dequeue(class: CHNumberCell.self, for: indexPath)
        case .switcher:
            return tableView.dequeue(class: ExmoSwitchCell.self, for: indexPath)
        case .segment:
            return tableView.dequeue(class: ExmoSegmentCell.self, for: indexPath)
        case .currencyDetails:
            return tableView.dequeue(class: CHSelectCurrencyCell.self, for: indexPath)
        case .button:
            return tableView.dequeue(class: CHButtonCell.self, for: indexPath)
        }
    }
}

class CellUIProperties {
    var titleColor: UIColor = .white
    var valueTintColor: UIColor = .backgroundColorSelectedCell
    var cellType: FormItemCellType?
    var height: CGFloat = 70.0
    var spacingBetweenRows: CGFloat = 15
    var keyboardType: UIKeyboardType = .default
    var textMaxLength: Int = 20
    var isUserInteractionEnabled = true
}

class SwitchCellUIProperties: CellUIProperties {
    var stateOnTintColor: UIColor = .dodgerBlue
    var stateOffTintColor: UIColor = .dark1
}

