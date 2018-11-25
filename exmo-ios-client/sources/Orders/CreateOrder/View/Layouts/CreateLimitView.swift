
//
//  CreateOrderLimitView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/13/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum CreateOrderDisplayType : Int {
    case Limit = 0
    case InstantOnAmount = 1
    case InstantOnSum = 2
}

class CreateOrderLimitView: UIView {
    enum CellType: Int {
        case CurrencyPair
        case Amount
        case Price
        case Total
        case Commision
        case OrderType
        case ButtonCreate
    }
    
    weak var parentVC: ExmoUIViewController!
    
    var orderType: OrderActionType = .Sell {
        didSet {
            guard let currency = selectedCurrency else {
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            let price = orderType == .Buy ? currency.buyPrice : currency.sellPrice
            updateSelectedCurrency(name: currency.code, price: price)
        }
    }
    
    weak var output: CreateOrderViewOutput!
    var selectedCurrency: TickerCurrencyModel? {
        didSet {
            print("did set selectedCurrency")
            guard let currency = selectedCurrency else {
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            let price = orderType == .Buy ? currency.buyPrice : currency.sellPrice
            updateSelectedCurrency(name: currency.code, price: price)
        }
    }
    let kCellId = "kCellId"
    let kCellIdMoreVariants = "kCellIdMoreVariants"
    let kCellButtonId = "CellButton"
    let kCellUISwitcherId = "kCellUISwitcher"
    
    var layoutType: CreateOrderDisplayType = .Limit {
        didSet {
            cells.removeAll()
            orderType = .Sell
            selectedCurrency = nil
            updateLayout(layoutType)
        }
    }
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        return tv
    }()
    
    var cells: [IndexPath: ExmoTableViewCell?] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CellInputField.self, forCellReuseIdentifier: kCellId)
        tableView.register(CellMoreVariantsField.self, forCellReuseIdentifier: kCellIdMoreVariants)
        tableView.register(CellButton.self, forCellReuseIdentifier: kCellButtonId)
        tableView.register(CellUISwitcher.self, forCellReuseIdentifier: kCellUISwitcherId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CreateOrderLimitView {
    func updateLayout(_ layoutType: CreateOrderDisplayType) {
        tableView.reloadData()
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        fillFields(number: 0)
        guard let cell = tableView.cellForRow(at: IndexPath(row: getSelectCurrencyIndexCell(), section: 0)) as? CellMoreVariantsField else { return }
        
        var model = ModelOrderViewCell(headerText: "Currency pair", placeholderText: "Select currency pair...", currencyName: name, rightText: String(price))
        model.isTextInputEnabled = false
        cell.model = model
    }
}
