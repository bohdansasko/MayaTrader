//
//  CHAlertsPresenter.swift
//  exmo-ios-client
//
//  Created by Office Mac on 8/10/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

protocol CHAlertsPresenterDelegate: class {
    func alertPresenter(_ presenter: CHAlertsPresenter, onAlertsDidLoaded alerts: [Alert])
    func alertPresenter(_ presenter: CHAlertsPresenter, onEdit alert: Alert)
}

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
    
    weak var delegate: CHAlertsPresenterDelegate?
    
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
        request.subscribe(onSuccess: { [weak self] alerts in
            guard let `self` = self else { return }
            self.alerts.items = alerts.sorted(by: { $0.dateCreated > $1.dateCreated })
            self.tableView.reloadData()
            self.delegate?.alertPresenter(self, onAlertsDidLoaded: alerts)
        }, onError: { err in
            print(err.localizedDescription)
            self.delegate?.alertPresenter(self, onAlertsDidLoaded: [])
        }).disposed(by: disposeBag)
    }
    
    func deleteAlerts(by action: AlertsDeleteAction) {
        print(#function, action)
        var alertsForDelete = [Alert]()
        switch (action) {
        case AlertsDeleteAction.all:
            alertsForDelete = alerts.items
        case AlertsDeleteAction.active:
            alertsForDelete = alerts.filter({ $0.status == .active })
        case AlertsDeleteAction.inactive:
            alertsForDelete = alerts.filter({ $0.status == .inactive })
        }
        let request = api.rx.deleteAlerts(alertsForDelete)
        request.subscribe(onSuccess: { [unowned self] in
            self.fetchAlerts()
        }, onError: { err in
            self.fetchAlerts()
        }).disposed(by: disposeBag)
    }
    
    func updateAlertState(at indexPath: IndexPath, on newStatus: AlertStatus) {
        guard let alert = alerts.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
        alert.status = newStatus
        
        let request = api.rx.updateAlert(alert)
        request.subscribe(onSuccess: {
            print("alert status updated")
        }, onError: { err in
            print(err)
        }).disposed(by: disposeBag)
    }
    
    func editAlert(by indexPath: IndexPath) {
        guard let alert = alerts.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
        delegate?.alertPresenter(self, onEdit: alert)
    }
    
    func removeAlert(by indexPath: IndexPath, _ completion: @escaping (Bool) -> Void) {
        guard let alert = alerts.getCellItem(byRow: indexPath.row) else {
            print("didSelectRowAt: item doesn't exists")
            return
        }
        let request = api.rx.deleteAlert(alert)
        request.subscribe(onSuccess: {
            completion(true)
        }, onError: { err in
            print(err.localizedDescription)
            completion(false)
        }).disposed(by: disposeBag)
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
            let newStatus = self.alerts.getStatus(forItem: indexPath.section) == .active
                ? AlertStatus.inactive
                : AlertStatus.active
            self.updateAlertState(at: indexPath, on: newStatus)
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
            self.removeAlert(by: indexPath) { success in
                completionHandler(success)
            }
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
