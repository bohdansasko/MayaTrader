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
    var ordersDataProvider: OrdersModel!
    weak var tableView: UITableView!
    var shouldUseActions: Bool = false
    
    // MARK: public methods
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return ordersDataProvider.isDataExists()
    }

    func showDataBySegment(displayOrderType: OrdersModel.DisplayOrderType) {
        self.ordersDataProvider = self.getDataBySegmentIndex(displayOrderType: displayOrderType)
        self.shouldUseActions = displayOrderType == .Opened
        reloadData()
    }

    // MARK: private methods
    private func getDataBySegmentIndex(displayOrderType: OrdersModel.DisplayOrderType) -> OrdersModel {
        switch displayOrderType {
            case .Opened: return Session.sharedInstance.getOpenedOrders()
            case .Canceled: return Session.sharedInstance.getCanceledOrders()
            default: return Session.sharedInstance.getDealsOrders()
        }
    }
}

extension OrdersDisplayManager: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.ordersDataProvider.getCountOrders()
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
        let orderData = self.ordersDataProvider.getOrderBy(index: indexPath.section)
        let cellId = TableCellIdentifiers.OrderTableViewCell.rawValue

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! OrderTableViewCell
        cell.setContent(orderData: orderData)

        return cell
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let whitespace = "         " // add the padding
        let deleteAction = UIContextualAction(style: .destructive, title: whitespace, handler: { action, view, completionHandler  in
            print("called delete action")
            completionHandler(true)
        })
        deleteAction.image = UIImage(named: "icNavbarTrash")
        deleteAction.backgroundColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 96/255.0, alpha: 1.0)

        let configurator = UISwipeActionsConfiguration(actions: [deleteAction])
        return configurator
    }
}
