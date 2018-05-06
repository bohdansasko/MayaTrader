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
    private var actions: [UITableViewRowAction]?
    
    var viewOutput: AlertsViewOutput!
    
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
        self.viewOutput.showEditView(data: dataProvider.getCellItem(byRow: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stateAction = UIContextualAction(style: .normal, title: "", handler: {
            _, _, _ in
            
        })
        stateAction.backgroundColor = UIColor(named: "exmoSteel")
        stateAction.image = #imageLiteral(resourceName: "icPause")
        
        let editAction = UIContextualAction(style: .normal, title: "", handler: {
            _, _, _ in
            
        })
        editAction.backgroundColor = UIColor(red: 115.0/255, green: 116.0/255, blue: 133.0/255, alpha: 1.0)
        editAction.image = #imageLiteral(resourceName: "icEdit")
        
        let removeAction = UIContextualAction(style: .normal, title: "", handler: {
            _, _, _ in
            
        })
        removeAction.backgroundColor = UIColor(named: "exmoOrangePink")
        removeAction.image = #imageLiteral(resourceName: "icNavbarTrash")
        
        let config = UISwipeActionsConfiguration(actions: [removeAction, editAction, stateAction])
        return config
    }
    
    private func getPauseActiontTitle(status: AlertStatus) -> String {
        var title = ""
        
        switch status {
        case .Active:
            title = "Pause"
        case .Inactive:
            title = "Resume"
        default:
            // do nothing
            break;
        }
        
        return title
    }
    
    private func getPauseActionStatus(status: AlertStatus) -> AlertStatus {
        var newStatus = status
        switch status {
        case .Active:
            newStatus = AlertStatus.Inactive
        case .Inactive:
            newStatus = AlertStatus.Active
        default:
            // do nothing
            break;
        }
        
        return newStatus
    }
}
