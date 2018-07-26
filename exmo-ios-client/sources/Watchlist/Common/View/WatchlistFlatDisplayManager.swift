//
//  WatchlistCurrencyPairModel.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class WatchlistFlatDisplayManager: NSObject {
    private var dataProvider: WatchlistCurrencyPairsModel!
    var tableView: UITableView!
    
    init(data: WatchlistCurrencyPairsModel) {
        self.dataProvider = data
        
        super.init()
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib = UINib(nibName: "WatchlistFlatTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: TableCellIdentifiers.WatchlistMenuViewCell.rawValue)
        
        self.reloadData()
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func isDataExists() -> Bool {
        return self.dataProvider.isDataExists()
    }
}


extension WatchlistFlatDisplayManager: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.getCountOrders()
    }
}

extension WatchlistFlatDisplayManager: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderData = self.dataProvider.getCurrencyPairBy(index: indexPath.row)
        let cellId = TableCellIdentifiers.WatchlistMenuViewCell.rawValue
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! WatchlistFlatTableViewCell
        cell.setContent(data: orderData)
        
        return cell
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
        let removeAction = UIContextualAction(style: .destructive, title: "", handler: {
            _, _, completionHandler in
            print("called delete action")
            self.dataProvider.removeItemBy(index: indexPath.section)
            completionHandler(true)
        })
        removeAction.backgroundColor = UIColor.orangePink
        removeAction.image = #imageLiteral(resourceName: "icNavbarTrash")
        
        let config = UISwipeActionsConfiguration(actions: [removeAction])
        return config
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
