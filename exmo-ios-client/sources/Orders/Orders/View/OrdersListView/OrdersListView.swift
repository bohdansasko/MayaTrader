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
    weak var view: OrdersViewInput!
    var shouldUseActions: Bool = false
    var displayOrderType: Orders.DisplayType = .None
    var tableViewCells: [Int64 : IndexPath] = [:]
    var dataProvider: Orders!
    let kCellId = "OrderCell"
    
    var openedOrders: Orders? {
        didSet {
            updateTableUI()
        }
    }
    var canceledOrders: Orders? {
        didSet {
            updateTableUI()
        }
    }
    var dealsOrders: Orders? {
        didSet {
            updateTableUI()
        }
    }
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.allowsSelection = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        return tv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: public methods
    func setupViews() {
        setupTableView()
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderViewCell.self, forCellReuseIdentifier: kCellId)
    }
    
    func updateTableUI() {
        checkOnRequirePlaceHolder()
        tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return dataProvider.isDataExists()
    }

    func showDataBySegment(displayOrderType: Orders.DisplayType) {
        self.displayOrderType = displayOrderType
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
    
    func appendOpenOrder(orderModel: OrderModel) {
        if (displayOrderType == .Open) {
            openedOrders = AppDelegate.session.getOpenOrders()
            dataProvider.append(orderModel: orderModel)
            tableView.insertSections(IndexSet(integer: 0), with: .automatic)
            checkOnRequirePlaceHolder()
        }
    }
    
    private func checkOnRequirePlaceHolder() {
        if (dataProvider.isDataExists()) {
            view.removePlaceholderNoData()
        } else {
            view.showPlaceholderNoData()
        }
    }
    
    func deleteAllOrders() {
        print("delete all orders")
        
        guard let openedOrders = openedOrders else {
            print("deleteAllOrders: openedOrders == nil")
            return
        }
        
        for order in openedOrders.getOrders() {
            let id = order.getId()
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
        
        let ordersOnBuy = openedOrders.getOrders().filter({ $0.getOrderActionType() == deleteOrderType })
        for order in ordersOnBuy {
            let id = order.getId()
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
    
}

extension OrdersListView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.getCountOrders()
    }
}

extension OrdersListView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 30
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.frame)
        view.backgroundColor = UIColor.black
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let order = dataProvider.getOrderBy(index: indexPath.section)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as! OrderViewCell
        cell.order = order
        
        tableViewCells[order.getId()] = indexPath
        
        return cell
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !shouldUseActions {
            let configurator = UISwipeActionsConfiguration(actions: [])
            return configurator
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: {
            [weak self] action, view, completionHandler  in
            guard let self = self else { return }
            
            let id = self.dataProvider.getOrderBy(index: indexPath.section).getId()
            if AppDelegate.session.cancelOpenOrder(id: id, byIndex: indexPath.section) {
                print("called delete action for row = ", indexPath.section)
                self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                self.checkOnRequirePlaceHolder()
            }
            completionHandler(true)
        })
        deleteAction.image = UIImage(named: "icNavbarTrash")
        deleteAction.backgroundColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 96/255.0, alpha: 1.0)

        let configurator = UISwipeActionsConfiguration(actions: [deleteAction])
        return configurator
    }
}
