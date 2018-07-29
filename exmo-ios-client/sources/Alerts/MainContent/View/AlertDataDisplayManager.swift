//
//  AlertDataDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertDataDisplayManager: NSObject {
    enum ActionType {
        case State
        case Edit
        case Delete
    }
    
    private var dataProvider: AlertsDisplayModel!
    private var tableView: UITableView!
    private var cells: [AlertTableViewCell] = []
    private var cellActions: [Int: [ActionType: UIContextualAction] ] = [:]

    
    var viewOutput: AlertsViewOutput!
    var view: AlertsViewInput!
    
    override init() {
        super.init()
        self.dataProvider = AlertsDisplayModel()
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.updateInfo()
    }
    
    func updateInfo() {
        self.dataProvider.setAlerts(alerts: Session.sharedInstance.getAlerts())
        self.tableView.reloadData()
        self.checkOnRequirePlaceHolder()
    }
    
    func getCountMenuItems() -> Int {
        return self.dataProvider.getCountMenuItems()
    }
    
    func appendAlert(alertItem: AlertItem) {
        self.dataProvider.appendAlert(alertItem: alertItem)
        self.tableView.insertSections(IndexSet(integer: 0), with: .automatic)
        self.checkOnRequirePlaceHolder()
    }

    func updateAlert(alertItem: AlertItem) {
        self.dataProvider.updateAlert(alertItem: alertItem)
        let index = self.dataProvider.getIndexById(alertId: alertItem.id)

        if let uiCell = getCellItem(elementIndex: index) {
            uiCell.setStatus(status: alertItem.status)
        }

        if index > -1 && index < self.cellActions.count {
            if let actionContainer = self.cellActions[index] {
                actionContainer[ActionType.State]?.image = self.dataProvider.getStatus(forItem: index) == .Active
                        ? #imageLiteral(resourceName:"icPause")
                        : #imageLiteral(resourceName:"icPlay")
            }
        }

        self.tableView.reloadSections(IndexSet(integer: index), with: .automatic)
    }

    func deleteById(alertId: String) {
        let index = self.dataProvider.getIndexById(alertId: alertId)
        self.dataProvider.removeItem(byId: alertId)
        self.tableView.deleteSections(IndexSet(integer: index), with: .automatic)
        self.checkOnRequirePlaceHolder()
    }

    func handleRemoveAction(elementIndex: Int) {
        guard let alertModel = self.dataProvider.getCellItem(byRow: elementIndex) else {
            print("handleRemoveAction: item doesn't exists")
            return
        }

        //
        // show activity view
        //
        APIService.socketManager.deleteAlert(alertId: alertModel.id)
    }
    
    func handleStateAction(elementIndex: Int) {
        self.dataProvider.reverseStatus(index: elementIndex)
        guard let alertModel = self.dataProvider.getCellItem(byRow: elementIndex) else {
            print("handleStateAction: item doesn't exists")
            return
        }
        APIService.socketManager.updateAlert(alertItem: alertModel)
    }
    
    func handleEditAction(elementIndex: Int) {
        guard let alertModel = self.dataProvider.getCellItem(byRow: elementIndex) else {
            print("handleStateAction: item doesn't exists")
            return
        }
        self.viewOutput.showEditView(data: alertModel)
    }
    
    private func getCellItem(elementIndex: Int) -> AlertTableViewCell? {
        return elementIndex > -1 && elementIndex < self.cells.count ? self.cells[elementIndex] : nil
    }
    
    private func checkOnRequirePlaceHolder() {
        if (self.dataProvider.isEmpty()) {
            self.view.showPlaceholderNoData()
        } else {
            self.view.removePlaceholderNoData()
        }
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
            break
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

extension AlertDataDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataProvider.getCountMenuItems()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: self.tableView.frame)
        view.backgroundColor = UIColor.black
        return view     
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let alertModel = self.dataProvider.getCellItem(byRow: indexPath.section) else {
            print("cellForRowAt: item doesn't exists")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.AlertTableViewCell.rawValue, for: indexPath) as! AlertTableViewCell
        cell.setData(data: alertModel)
        self.cells.append(cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let alertModel = self.dataProvider.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
        self.viewOutput.showEditView(data: alertModel)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let stateAction = UIContextualAction(style: .normal, title: "", handler: {
            action, _, completionHandler in
            print("alert: state action clicked")
            self.handleStateAction(elementIndex: indexPath.section) // TODO: change state after got response from server

            completionHandler(true)
        })
        stateAction.backgroundColor = self.dataProvider.getStatus(forItem: indexPath.section) == .Active
            ? UIColor.steel
            : UIColor.greenBlue
        stateAction.image = self.dataProvider.getStatus(forItem: indexPath.section) == .Active ? #imageLiteral(resourceName: "icPause") : #imageLiteral(resourceName: "icPlay")
        
        let editAction = UIContextualAction(style: .normal, title: "", handler: {
            _, _, completionHandler in
            print("alert: edit action clicked")
            self.handleEditAction(elementIndex: indexPath.section)
            
            completionHandler(true)
        })
        editAction.backgroundColor = UIColor(red: 115.0/255, green: 116.0/255, blue: 133.0/255, alpha: 1.0)
        editAction.image = #imageLiteral(resourceName: "icEdit")
        
        let removeAction = UIContextualAction(style: .destructive, title: "", handler: {
            _, _, completionHandler in
            print("alert: remove action clicked: row \(indexPath.section)")
            self.handleRemoveAction(elementIndex: indexPath.section)
            
            completionHandler(true)
        })
        removeAction.backgroundColor = UIColor.orangePink
        removeAction.image = #imageLiteral(resourceName: "icNavbarTrash")

        self.cellActions[indexPath.section] = [
            ActionType.Delete : removeAction,
            ActionType.Edit   : editAction,
            ActionType.State  : stateAction
        ]

        let config = UISwipeActionsConfiguration(actions: [removeAction, editAction, stateAction])
        return config
    }
}
