//
//  Cells.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/30/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

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
    case Switcher
    
    static func registerCells(for tableView: UITableView) {
        tableView.register(ExmoFloatingNumberCell.self, forCellReuseIdentifier: String(describing: ExmoFloatingNumberCell.self))
        tableView.register(ExmoSwitchCell.self, forCellReuseIdentifier: String(describing: ExmoSwitchCell.self))

    }
    
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch self {
        case .TextField:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: ExmoFloatingNumberCell.self), for: indexPath)
        case .Switcher:
            return tableView.dequeueReusableCell(withIdentifier: String(describing: ExmoSwitchCell.self), for: indexPath)
        }
    }
}

class CellUIProperties {
    var titleColor: UIColor = .white
    var valueTintColor: UIColor = .backgroundColorSelectedCell
    var cellType: FormItemCellType?
    var height: CGFloat = 0.0
}

class SwitchCellUIProperties: CellUIProperties {
    var stateOnTintColor: UIColor = .dodgerBlue
    var stateOffTintColor: UIColor = .dark1
}

