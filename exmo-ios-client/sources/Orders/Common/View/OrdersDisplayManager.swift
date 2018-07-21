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
    
    var openedOrders: OrdersModel?
    var canceledOrders: OrdersModel?
    var dealsOrders: OrdersModel?

    
    // MARK: public methods
    func setTableView(tableView: UITableView!) {
        self.dataProvider = OrdersModel()
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.checkOnRequirePlaceHolder()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return self.dataProvider.isDataExists()
    }

    func showDataBySegment(displayOrderType: OrdersModel.DisplayOrderType) {
        guard let data = self.getDataBySegmentIndex(displayOrderType: displayOrderType) else {
            return
        }
        self.dataProvider = data
        self.checkOnRequirePlaceHolder()
        self.shouldUseActions = displayOrderType == .Opened
        self.reloadData()
    }

    // MARK: private methods
    private func getDataBySegmentIndex(displayOrderType: OrdersModel.DisplayOrderType) -> OrdersModel? {
        switch displayOrderType {
            case .Opened: return self.openedOrders
            case .Canceled: return self.canceledOrders
            default: return self.dealsOrders
        }
    }
    
    func setOrdersData(openedOrders: OrdersModel, canceledOrders: OrdersModel) {
        self.openedOrders = openedOrders
        self.canceledOrders = canceledOrders
        self.dealsOrders = OrdersModel(orders: openedOrders.getOrders() + canceledOrders.getOrders())
    }
    
    private func checkOnRequirePlaceHolder() {
        if (self.dataProvider.isDataExists()) {
            self.view.removePlaceholderNoData()
        } else {
            self.view.showPlaceholderNoData()
        }
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

        return cell
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.shouldUseActions {
            let configurator = UISwipeActionsConfiguration(actions: [])
            return configurator
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "", handler: { action, view, completionHandler  in
            print("called delete action for row = ", indexPath.section)
            self.dataProvider.cancelOpenedOrder(byIndex: indexPath.section)
            self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.top)
            Session.sharedInstance.cancelOpenedOrder(byIndex: indexPath.section)
            self.checkOnRequirePlaceHolder()
            completionHandler(false)
        })
        deleteAction.image = UIImage(named: "icNavbarTrash")
        deleteAction.backgroundColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 96/255.0, alpha: 1.0)

        let configurator = UISwipeActionsConfiguration(actions: [deleteAction])
        return configurator
    }
}
