//
//  OrdersDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class OrdersDisplayManager: NSObject {    
    // MARK: outlets
    var dataProvider: OrdersModel!
    weak var tableView: UITableView!
    weak var view: OrdersManagerViewInput!
    
    var shouldUseActions: Bool = false
    var displayOrderType: OrdersModel.DisplayOrderType = .None
    
    var openedOrders: OrdersModel?
    var canceledOrders: OrdersModel?
    var dealsOrders: OrdersModel?

    var tableViewCells: [Int64 : IndexPath] = [:]
    
    // MARK: public methods
    func setTableView(tableView: UITableView!) {
        self.dataProvider = OrdersModel()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.checkOnRequirePlaceHolder()
    }
    
    func updateTableUI() {
        self.checkOnRequirePlaceHolder()
        self.tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return self.dataProvider.isDataExists()
    }

    func showDataBySegment(displayOrderType: OrdersModel.DisplayOrderType) {
        self.displayOrderType = displayOrderType
        guard let data = self.getDataBySegmentIndex(displayOrderType: displayOrderType) else {
            self.dataProvider = OrdersModel()
            self.updateTableUI()
            return
        }
        self.dataProvider = data
        self.shouldUseActions = displayOrderType == .Open
        self.updateTableUI()
    }

    // MARK: private methods
    private func getDataBySegmentIndex(displayOrderType: OrdersModel.DisplayOrderType) -> OrdersModel? {
        switch displayOrderType {
            case .Open: return self.openedOrders
            case .Canceled: return self.canceledOrders
            default: return self.dealsOrders
        }
    }
    
    func setOpenOrders(orders: OrdersModel) {
        self.openedOrders = orders
    }
    
    func setCanceledOrders(orders: OrdersModel) {
        self.canceledOrders = orders
    }
    
    func setDealsOrders(orders: OrdersModel) {
        self.dealsOrders = orders
    }

    func appendOpenOrder(orderModel: OrderModel) {
        if (self.displayOrderType == .Open) {
            setOpenOrders(orders: AppDelegate.session.getOpenOrders())
            self.dataProvider.append(orderModel: orderModel)
            self.tableView.insertSections(IndexSet(integer: 0), with: .automatic)
            self.checkOnRequirePlaceHolder()
        }
    }
    
    private func checkOnRequirePlaceHolder() {
        if (self.dataProvider.isDataExists()) {
            self.view.removePlaceholderNoData()
        } else {
            self.view.showPlaceholderNoData()
        }
    }
    
    func deleteAllOrders() {
        print("delete all orders")
        
        guard let openedOrders = self.openedOrders else {
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
            
            self.dataProvider.clear()
            self.openedOrders?.clear()
            self.tableView.reloadData()
        }
        self.checkOnRequirePlaceHolder()
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
        guard let openedOrders = self.openedOrders else {
            print("deleteOrders: openedOrders == nil")
            return
        }
        
        let ordersOnBuy = openedOrders.getOrders().filter({ $0.getOrderActionType() == deleteOrderType })
        for order in ordersOnBuy {
            let id = order.getId()
            guard let indexPath = self.tableViewCells[id] else {
                continue
            }
            let shouldDeleteSection = self.displayOrderType == .Open
            if AppDelegate.session.cancelOpenOrder(id: id, byIndex: indexPath.section) {
                self.openedOrders?.removeItem(byIndex: indexPath.section)
                if shouldDeleteSection {
                    self.dataProvider.removeItem(byIndex: indexPath.section)
                    self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                }
            }
        }
        
        self.checkOnRequirePlaceHolder()
    }
    
    func getPickerViewLayout() -> DarkeningPickerViewModel {
        return DarkeningPickerViewModel(
            header: "Delete orders",
            dataSouce: ["Delete All", "Delete All on buy", "Delete All on sell"])
    }
}

extension OrdersDisplayManager: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataProvider.getCountOrders()
    }
}

extension OrdersDisplayManager: UITableViewDelegate  {
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
        let view = UIView(frame: self.tableView.frame)
        view.backgroundColor = UIColor.black
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderData = self.dataProvider.getOrderBy(index: indexPath.section)
        let cellId = TableCellIdentifiers.OrderTableViewCell.rawValue

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderTableViewCell
        cell.setContent(orderData: orderData)
        
        self.tableViewCells[orderData.getId()] = indexPath
        
        return cell
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.shouldUseActions {
            let configurator = UISwipeActionsConfiguration(actions: [])
            return configurator
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHandler  in
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
