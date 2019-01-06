//
//  OrdersListView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class OrdersListView: UIView {
    var tableView: UITableView = {
        let tv = UITableView()
        tv.allowsSelection = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        return tv
    }()
    
    private var placeholderNoData: PlaceholderNoDataView = {
        let view = PlaceholderNoDataView()
        view.isHidden = true
        return view
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        return aiv
    }()

    var showTutorialAddOrder: VoidClosure?
    var hideTutorialAddOrder: VoidClosure?

    weak var presenter: OrdersViewOutput!
    var dataProvider: Orders!
    var tableViewCells: [Int64 : IndexPath] = [:]
    var displayOrderType: Orders.DisplayType = .None {
        didSet {
            showDataBySegment(displayOrderType: displayOrderType)
        }
    }
    let kCellId = "OrderCell"
    var shouldUseActions: Bool = false
    
    var openedOrders: Orders? {
        didSet { displayOrderType = .Open }
    }
    var canceledOrders: Orders? {
        didSet { displayOrderType = .Canceled }
    }
    var dealsOrders: Orders? {
        didSet { displayOrderType = .Deals }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func isDataExists() -> Bool {
        return dataProvider.isDataExists()
    }

    func showDataBySegment(displayOrderType: Orders.DisplayType) {
        guard let data = getDataBySegmentIndex(displayOrderType: displayOrderType) else {
            dataProvider = Orders()
            updateTableUI()
            return
        }
        dataProvider = data
        shouldUseActions = displayOrderType == .Open
        updateTableUI()
    }

    // MARK: private methods
    private func getDataBySegmentIndex(displayOrderType: Orders.DisplayType) -> Orders? {
        switch displayOrderType {
            case .Open: return openedOrders
            case .Canceled: return canceledOrders
            default: return dealsOrders
        }
    }
}

// MARK: setup UI
extension OrdersListView {
    func updateTableUI() {
        checkOnRequirePlaceHolder()
        tableView.reloadData()
    }
    
    func setupViews() {
        setupTableView()
        setupPlaceholderNoData()
        
        addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
    }
    
    private func setupPlaceholderNoData() {
        self.addSubview(placeholderNoData)
        let topOffset: CGFloat = AppDelegate.isIPhone(model: .Five) ? -5 : 50
        placeholderNoData.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderViewCell.self, forCellReuseIdentifier: kCellId)
    }
    
    func checkOnRequirePlaceHolder() {
        if (dataProvider.isDataExists()) {
            activityIndicatorView.stopAnimating()
            removePlaceholderNoData()
        } else {
            removePlaceholderNoData()
            activityIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                [weak self] in
                guard let isDataExists = self?.dataProvider.isDataExists() else { return }
                if (!isDataExists) {
                    self?.activityIndicatorView.stopAnimating()
                    self?.showPlaceholderNoData()
                }
            })
        }
    }
}

// @MARK: help operations for orders
extension OrdersListView {
    func appendOpenOrder(orderModel: OrderModel) {
        if (displayOrderType == .Open) {
            openedOrders = AppDelegate.session.getOpenOrders()
            dataProvider.append(orderModel: orderModel)
            tableView.insertSections(IndexSet(integer: 0), with: .automatic)
            checkOnRequirePlaceHolder()
        }
    }

    func deleteAllOrdersOnBuy() {
        print("delete all orders on buy")
        deleteAllOrdersOn(deleteOrderType: .Buy)
    }

    func deleteAllOrdersOnSell() {
        print("delete all orders on sell")
        deleteAllOrdersOn(deleteOrderType: .Sell)
    }

    private func deleteAllOrdersOn(deleteOrderType: OrderActionType) {
        guard let openedOrders = openedOrders else {
            print("deleteOrders: openedOrders == nil")
            return
        }
        
        let ordersOnBuy = openedOrders.getOrders().filter({ $0.orderType == deleteOrderType })
        for order in ordersOnBuy {
            let id = order.id
            guard let indexPath = tableViewCells[id] else {
                continue
            }
            let shouldDeleteSection = displayOrderType == .Open
            if AppDelegate.session.cancelOpenOrder(id: id, byIndex: indexPath.section) {
                openedOrders.removeItem(byIndex: indexPath.section)
                if shouldDeleteSection {
                    dataProvider.removeItem(byIndex: indexPath.section)
                    tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
            }
        }
        
        checkOnRequirePlaceHolder()
    }
    
    func deleteAllOrders() {
        print("delete all orders")
        
        guard let openedOrders = openedOrders else {
            print("deleteAllOrders: openedOrders == nil")
            return
        }
        
        for order in openedOrders.getOrders() {
            let id = order.id
            if AppDelegate.session.cancelOpenOrder(id: id, byIndex: -1) {
                // do nothing
            }
        }
        
        if displayOrderType == .Open {
            AppDelegate.session.getOpenOrders().clear()
            dataProvider.clear()
            openedOrders.clear()
            tableView.reloadData()
        }
        
        checkOnRequirePlaceHolder()
    }
    
    func orderWasCanceled(id: Int64) {
        guard let indexPath = tableViewCells[id] else {
            print("orderWasCanceled: can't find cell for remove")
            return
        }
        dataProvider.removeItem(byIndex: indexPath.section)
        tableViewCells.removeValue(forKey: id)
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        checkOnRequirePlaceHolder()
    }
}

// @MARK: placeholder
extension OrdersListView {
    func showPlaceholderNoData() {
        placeholderNoData.isHidden = displayOrderType == .Open
        switch displayOrderType {
        case .Open:
            showTutorialAddOrder?()
            placeholderNoData.text = nil
        case .Canceled:
            placeholderNoData.text = "You haven't canceled orders right now"
        case .Deals:
            placeholderNoData.text = "You haven't deals orders right now"
        default: break
        }
    }
    
    func removePlaceholderNoData() {
        placeholderNoData.isHidden = true
        hideTutorialAddOrder?()
    }
}
