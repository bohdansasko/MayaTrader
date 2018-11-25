//
//  OrdersListView+UITableViewDelegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/24/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// @MARK: UITableViewDataSource
extension OrdersListView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.getCountOrders()
    }
}

// @MARK: UITableViewDelegate
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
        
        tableViewCells[order.id] = indexPath
        
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
            
            self.activityIndicatorView.startAnimating()
            let id = self.dataProvider.getOrderBy(index: indexPath.section).id
            self.presenter.cancelOrder(id: id)
            
            print("called delete action for row = \(id), \(indexPath.section)")
            
            completionHandler(true)
        })
        deleteAction.image = UIImage(named: "icNavbarTrash")
        deleteAction.backgroundColor = UIColor(red: 255/255.0, green: 105/255.0, blue: 96/255.0, alpha: 1.0)
        
        let configurator = UISwipeActionsConfiguration(actions: [deleteAction])
        return configurator
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
