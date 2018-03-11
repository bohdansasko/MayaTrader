//
//  AlertDataDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertDataDisplayManager: NSObject {
    private var dataProvider: AlertsDisplayModel!
    private var tableView: UITableView!
    
    var interactor: AlertsInteractorInput!
    
    override init() {
        super.init()
        dataProvider = AlertsDisplayModel()
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.updateInfo()
    }
    
    func updateInfo() {
        dataProvider.update()
        self.tableView.reloadData()
    }
    
    func getCountMenuItems() -> Int {
        return dataProvider.getCountMenuItems()
    }
}

extension AlertDataDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.getCountMenuItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.AlertTableViewCell.rawValue, for: indexPath) as! AlertTableViewCell
        cell.setData(data: self.dataProvider.getCellItem(byRow: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // alert become in edit state in new view
    }
}
