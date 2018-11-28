
//
//  AlertsListView+Datasource+Delegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// @MARK: UITableViewDataSource
extension AlertsListView: UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataProvider.getCountMenuItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let alert = dataProvider.getCellItem(byRow: indexPath.section) else {
            print("cellForRowAt: item doesn't exists")
            return
        }
        
        let cell = cell as! AlertViewCell
        cell.item = alert
        
        cells.append(cell)
    }
}

// @MARK: UITableViewDelegate
extension AlertsListView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.frame)
        view.backgroundColor = UIColor.black
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let alertModel = dataProvider.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
        viewOutput.editAlert(alertModel)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let stateAction = UIContextualAction(style: .normal, title: "", handler: {
            [weak self] action, _, completionHandler in
            print("alert: state action clicked")
            self?.handleStateAction(elementIndex: indexPath.section)
            completionHandler(true)
        })
        stateAction.backgroundColor = dataProvider.getStatus(forItem: indexPath.section) == .Active
            ? UIColor.steel
            : UIColor.greenBlue
        stateAction.image = dataProvider.getStatus(forItem: indexPath.section) == .Active ? #imageLiteral(resourceName: "icPause") : #imageLiteral(resourceName: "icPlay")
        
        let editAction = UIContextualAction(style: .normal, title: "", handler: {
            [weak self] _, _, completionHandler in
            print("alert: edit action clicked")
            self?.handleEditAction(elementIndex: indexPath.section)
            completionHandler(true)
        })
        editAction.backgroundColor = UIColor(red: 115.0/255, green: 116.0/255, blue: 133.0/255, alpha: 1.0)
        editAction.image = #imageLiteral(resourceName: "icEdit")
        
        let removeAction = UIContextualAction(style: .destructive, title: "", handler: {
            [weak self] _, _, completionHandler in
            print("alert: remove action clicked: row \(indexPath.section)")
            self?.handleRemoveAction(elementIndex: indexPath.section)
            completionHandler(true)
        })
        removeAction.backgroundColor = UIColor.orangePink
        removeAction.image = #imageLiteral(resourceName: "icNavbarTrash")
        
        cellActions[indexPath.section] = [
            ActionType.Delete : removeAction,
            ActionType.Edit   : editAction,
            ActionType.State  : stateAction
        ]
        
        let config = UISwipeActionsConfiguration(actions: [removeAction, editAction, stateAction])
        return config
    }
}
