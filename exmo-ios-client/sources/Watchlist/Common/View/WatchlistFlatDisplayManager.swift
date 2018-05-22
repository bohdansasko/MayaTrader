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
        return dataProvider.isDataExists()
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .normal, title: "Delete", handler: { action, indexPath in
            print("called delete action")
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
