
//
//  CreateOrderLimitView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/13/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

enum OrderBy {
    case Market
    case CurrencyExchange
}

enum CreateOrderDisplayType : Int {
    case Limit = 0
    case InstantOnAmount = 1
    case InstantOnSum = 2
}

class CreateOrderLimitView: UIView {    
    weak var parentVC: ExmoUIViewController!
    lazy var form = FormCreateOrder()
    
    var orderType: OrderActionType = .Sell {
        didSet {
            guard let currency = selectedCurrency else {
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            updateSelectedCurrency(name: currency.code, price: currency.lastTrade)
        }
    }
    
    weak var output: CreateOrderViewOutput!
    var selectedCurrency: TickerCurrencyModel? {
        didSet {
            print("did set selectedCurrency")
            guard let currency = selectedCurrency else {
                print("currency == nil")
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            updateSelectedCurrency(name: currency.code, price: currency.lastTrade)
        }
    }
    
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
    
    var cells: [IndexPath: UITableViewCell] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        form.viewIsReady()
        
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        FormItemCellType.registerCells(for: tableView)
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
        guard let cell = cells[IndexPath(row: 0, section: 0)] as? CurrencyDetailsCell else { return }
        let formItem = cell.formItem
        formItem?.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: name)
        formItem?.rightValue = Utils.getFormatedPrice(value: price, maxFractDigits: 9)
        cell.update(item: formItem)
    }
}
