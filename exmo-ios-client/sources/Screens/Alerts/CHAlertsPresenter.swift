//
//  CHAlertsPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/10/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

final class CHAlertsPresenter: NSObject {
    fileprivate enum ActionType {
        case state
        case edit
        case delete
    }
    
    fileprivate weak var tableView: UITableView!
    fileprivate let api: VinsoAPI
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var alerts = AlertsModel()
    fileprivate var cellActions: [Int: [ActionType: UIContextualAction] ] = [:]
    fileprivate let kCellId = "alertCellId"
    
    
    init(tableView: UITableView, api: VinsoAPI) {
        self.tableView = tableView
        self.api = api
        
        super.init()
        
        setupTableView()
    }

}

// MARK: - Setup

private extension CHAlertsPresenter {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(class: AlertViewCell.self)
    }
    
}

// MARK - Manage alerts

extension CHAlertsPresenter {
    
    func fetchAlerts() {
        let request = api.rx.getAlerts()
        request.subscribe(onNext: { [unowned self] alerts in
            self.alerts.items = alerts
            self.tableView.reloadData()
        }, onError: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func deleteAlerts(by action: AlertsDeleteAction) {
        print(#function, action)
        var alertsForRemove = [Alert]()
        switch (action) {
        case AlertsDeleteAction.all:
            alertsForRemove = alerts.items
        case AlertsDeleteAction.active:
            alertsForRemove = alerts.filter({ $0.status == .active })
        case AlertsDeleteAction.inactive:
            alertsForRemove = alerts.filter({ $0.status == .inactive })
        }
//        doDeleteAlerts(ids: alertsForRemove.map({ $0.id }))
    }
    
    func updateAlertState(by indexPath: IndexPath) {
        guard let alertModel = alerts.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
    }
    
    func editAlert(by indexPath: IndexPath) {
        guard let alertModel = alerts.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
    }
    
    func removeAlert(by indexPath: IndexPath) {
        guard let alertModel = alerts.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
    }
    
}

// MARK: - UITableViewDataSource

extension CHAlertsPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alerts.count()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: AlertViewCell.self, for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let alert = alerts.getCellItem(byRow: indexPath.section)
        let alertCell = cell as! AlertViewCell
        alertCell.item = alert
    }
    
}

// MARK: - UITableViewDelegate

extension CHAlertsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        editAlert(by: indexPath)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let stateAction = UIContextualAction(style: .normal, title: "", handler: {
            [unowned self] action, _, completionHandler in
            print("alert: state action clicked")
            self.updateAlertState(by: indexPath)
            completionHandler(true)
        })
        stateAction.backgroundColor = alerts.getStatus(forItem: indexPath.section) == .active
            ? UIColor.steel
            : UIColor.greenBlue
        stateAction.image = alerts.getStatus(forItem: indexPath.section) == .active ? #imageLiteral(resourceName: "icPause") : #imageLiteral(resourceName: "icPlay")
        
        let editAction = UIContextualAction(style: .normal, title: "", handler: {
            [unowned self] _, _, completionHandler in
            print("alert: edit action clicked")
            self.editAlert(by: indexPath)
            completionHandler(true)
        })
        editAction.backgroundColor = UIColor(red: 115.0/255, green: 116.0/255, blue: 133.0/255, alpha: 1.0)
        editAction.image = #imageLiteral(resourceName: "icEdit")
        
        let removeAction = UIContextualAction(style: .destructive, title: "", handler: {
            [unowned self] _, _, completionHandler in
            print("alert: remove action clicked: row \(indexPath.section)")
            self.removeAlert(by: indexPath)
            completionHandler(true)
        })
        removeAction.backgroundColor = UIColor.orangePink
        removeAction.image = #imageLiteral(resourceName: "icNavbarTrash")
        
        cellActions[indexPath.section] = [
            ActionType.delete : removeAction,
            ActionType.edit   : editAction,
            ActionType.state  : stateAction
        ]
        
        let config = UISwipeActionsConfiguration(actions: [removeAction, editAction, stateAction])
        return config
    }
    
}
