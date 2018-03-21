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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction.init(style: .normal, title: "Edit", handler: { [unowned self] action, indexPath in
            self.viewOutput.showEditView(data: self.dataProvider.getCellItem(byRow: indexPath.row))
            print("called edit action")
        })
        editAction.backgroundColor = UIColor.green

        let pauseTitle = getPauseActiontTitle(status: self.dataProvider.getStatus(forItem: indexPath.row))
        let pauseAction = UITableViewRowAction.init(style: .normal, title: pauseTitle, handler: { [unowned self] action, indexPath in
            let status = self.getPauseActionStatus(status: self.dataProvider.getStatus(forItem: indexPath.row))
            self.dataProvider.setState(forItem: indexPath.row, status: status)
            print("called pause action")
        })
        pauseAction.backgroundColor = UIColor.gray


        let deleteAction = UITableViewRowAction.init(style: .normal, title: "Delete", handler: { [unowned self] action, indexPath in
            self.dataProvider.removeItem(atRow: indexPath.row)
            self.tableView.reloadData()
            print("called delete action")
        })
        
        deleteAction.backgroundColor = UIColor.red
        actions = [deleteAction, pauseAction, editAction]
        return actions
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
