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

protocol FormUpdatable {
    func update(item: FormItem?)
}


enum FormItemCellType {
    case TextField
    case FloatingNumberTextField
    case Switcher
    case CurrencyDetails
    case Button
    
    static func registerCells(for tableView: UITableView) {
        tableView.register(TextFieldCell.self, forCellReuseIdentifier: String(describing: TextFieldCell.self))
        tableView.register(ExmoFloatingNumberCell.self, forCellReuseIdentifier: String(describing: ExmoFloatingNumberCell.self))
        tableView.register(ExmoSwitchCell.self, forCellReuseIdentifier: String(describing: ExmoSwitchCell.self))
        tableView.register(CurrencyDetailsCell.self, forCellReuseIdentifier: String(describing: CurrencyDetailsCell.self))
        tableView.register(ButtonCell.self, forCellReuseIdentifier: String(describing: ButtonCell.self))
    }
    
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch self {
        case .TextField:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: TextFieldCell.self), for: indexPath)
        case .FloatingNumberTextField:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: ExmoFloatingNumberCell.self), for: indexPath)
        case .Switcher:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: ExmoSwitchCell.self), for: indexPath)
        case .CurrencyDetails:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: CurrencyDetailsCell.self), for: indexPath)
        case .Button:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: ButtonCell.self), for: indexPath)
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
}

class SwitchCellUIProperties: CellUIProperties {
    var stateOnTintColor: UIColor = .dodgerBlue
    var stateOffTintColor: UIColor = .dark1
}
