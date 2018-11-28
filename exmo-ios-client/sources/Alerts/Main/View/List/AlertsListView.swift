//
//  AlertsListView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/11/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class AlertsListView: UIView {
    enum ActionType {
        case State
        case Edit
        case Delete
    }
    
    var dataProvider: AlertsModel!
    var cells: [AlertViewCell] = []
    var cellActions: [Int: [ActionType: UIContextualAction] ] = [:]

    private var placeholderNoData: PlaceholderNoDataView = {
        let view = PlaceholderNoDataView()
        view.text = "You haven't alerts right now"
        view.isHidden = true
        return view
    }()
    
    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        return tv
    }()
    
    weak var viewOutput: AlertsViewOutput!
    weak var view: AlertsViewInput!
    
    let kCellId = "alertCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
        dataProvider = AlertsModel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlertViewCell.self, forCellReuseIdentifier: kCellId)
    }
    
    func updateInfo() {
        dataProvider.setAlerts(alerts: AppDelegate.session.getAlerts())
        tableView.reloadData()
        checkOnRequirePlaceHolder()
    }
    
    func getCountMenuItems() -> Int {
        return dataProvider.getCountMenuItems()
    }
    
    func appendAlert(alertItem: Alert) {
        dataProvider.append(alertItem: alertItem)
        tableView.insertSections(IndexSet(integer: 0), with: .automatic)
        checkOnRequirePlaceHolder()
    }

    func updateAlert(alertItem: Alert) {
        dataProvider.updateAlert(alertItem: alertItem)
        let index = dataProvider.getIndexById(alertId: alertItem.id)

        if let uiCell = getCellItem(elementIndex: index) {
//            uiCell.setStatus(status: alertItem.status)
        }

        if index > -1 && index < cellActions.count {
            if let actionContainer = cellActions[index] {
                actionContainer[ActionType.State]?.image = dataProvider.getStatus(forItem: index) == .Active
                        ? #imageLiteral(resourceName:"icPause")
                        : #imageLiteral(resourceName:"icPlay")
            }
        }

        tableView.reloadSections(IndexSet(integer: index), with: .automatic)
    }

    func deleteById(alertId: String) {
        let index = dataProvider.getIndexById(alertId: alertId)
        dataProvider.removeItem(byId: alertId)
        tableView.deleteSections(IndexSet(integer: index), with: .automatic)
        checkOnRequirePlaceHolder()
    }

    func handleRemoveAction(elementIndex: Int) {
        guard let alertModel = dataProvider.getCellItem(byRow: elementIndex) else {
            print("handleRemoveAction: item doesn't exists")
            return
        }

        //
        // show activity view
        //
        AppDelegate.session.deleteAlert(alertId: alertModel.id)
    }
    
    func handleStateAction(elementIndex: Int) {
        dataProvider.reverseStatus(index: elementIndex)
        guard let alertModel = dataProvider.getCellItem(byRow: elementIndex) else {
            print("handleStateAction: item doesn't exists")
            return
        }
        AppDelegate.roobikController.updateAlert(alertItem: alertModel)
    }
    
    func handleEditAction(elementIndex: Int) {
        guard let alertModel = dataProvider.getCellItem(byRow: elementIndex) else {
            print("handleStateAction: item doesn't exists")
            return
        }
        viewOutput.editAlert(alertModel)
    }
    
    private func getCellItem(elementIndex: Int) -> AlertViewCell? {
        return elementIndex > -1 && elementIndex < cells.count ? cells[elementIndex] : nil
    }
    
    private func checkOnRequirePlaceHolder() {
        if (dataProvider.isEmpty()) {
            placeholderNoData.isHidden = false
        } else {
            placeholderNoData.isHidden = true
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

extension AlertsListView {
    //    private func setupPlaceholderNoData() {
    //        view.addSubview(placeholderNoData)
    //        let topOffset: CGFloat = AppDelegate.isIPhone(model: .Five) ? 35 : 90
    //        placeholderNoData.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    //    }
    //
}
