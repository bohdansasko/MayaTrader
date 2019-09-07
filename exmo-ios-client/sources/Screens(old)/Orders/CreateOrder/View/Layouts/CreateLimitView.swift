
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
    case market
    case currencyExchange
}

enum CreateOrderDisplayType : Int {
    case limit = 0
    case instantOnAmount = 1
    case instantOnSum = 2
}

class CreateOrderLimitView: UIView {
    weak var output: CreateOrderViewOutput!
    weak var parentVC: ExmoUIViewController!
    lazy var form = FormCreateOrder()
    
    var orderType: OrderActionType = .sell {
        didSet {
            guard let currency = selectedCurrency else {
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            updateSelectedCurrency(name: currency.code, price: currency.lastTrade)
        }
    }

    var selectedCurrency: TickerCurrencyModel? {
        didSet {
            log.debug("did set currency \(selectedCurrency?.code ?? "<nil>")")
            guard let currency = selectedCurrency else {
                log.debug("currency == nil")
                updateSelectedCurrency(name: "", price: 0)
                return
            }
            updateSelectedCurrency(name: currency.code, price: currency.lastTrade)
        }
    }
    
    var layoutType: CreateOrderDisplayType = .limit {
        didSet {
            cells.removeAll()
            orderType = .buy
            updateLayout(layoutType)
            
            parentVC.hideLoader()
            setTouchEnabled(true)
        }
    }
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    var cells: [IndexPath: UITableViewCell] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        form.delegate = self
        form.viewIsReady()
        
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        FormItemCellType.registerCells(for: tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
    }
}

extension CreateOrderLimitView {
    func updateLayout(_ layoutType: CreateOrderDisplayType) {
        form.clearForm()
        tableView.reloadData()
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        guard let cell = cells[IndexPath(row: 0, section: 0)] as? CurrencyDetailsCell else {
            log.debug("cell haven't found")
            guard let item = form.tabs[layoutType.rawValue].cellItems[0] as? CurrencyDetailsItem,
                  name != "" else {
                log.error("fail cast to CurrencyDetailsItem")
                return
            }
            item.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: name)
            item.rightValue = Utils.getFormatedPrice(value: price, maxFractDigits: 9)
            return
        }
        let formItem = cell.formItem
        formItem?.leftValue = Utils.getDisplayCurrencyPair(rawCurrencyPairName: name)
        formItem?.rightValue = Utils.getFormatedPrice(value: price, maxFractDigits: 9)
        cell.update(item: formItem)
    }
}

extension CreateOrderLimitView: FormCreateOrderDelegate {
    func createOrder(_ order: OrderModel) {
        parentVC.showLoader()
        setTouchEnabled(false)
        output.createOrder(orderModel: order)
    }

    func setTouchEnabled(_ isEnabled: Bool) {
        form.setTouchEnabled(isEnabled)
    }
}
