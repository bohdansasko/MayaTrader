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

    weak var presenter: AlertsViewOutput!
    lazy var alerts = AlertsModel()
    var cells: [AlertViewCell] = []
    var cellActions: [Int: [ActionType: UIContextualAction] ] = [:]
    let kCellId = "alertCellId"

    var tutorialImg: TutorialImage = {
        let img = TutorialImage()
        img.imageName = "imgTutorialAlert"
        img.offsetByY = -60
        return img
    }()

    var tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        return tv
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTutorialImg()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func invalidate() {
        tableView.reloadData()
        checkOnRequirePlaceHolder()
    }

    private func checkOnRequirePlaceHolder() {
        if (alerts.isEmpty()) {
            tutorialImg.show()
        } else {
            tutorialImg.hide()
        }
    }
}

// @MARK: append/update/delete cell
extension AlertsListView {
    func appendAlert(alertItem: Alert) {
        alerts.append(alertItem: alertItem)
        tableView.insertSections(IndexSet(integer: 0), with: .automatic)
        checkOnRequirePlaceHolder()
    }

    func updateAlert(alertItem: Alert) {
        alerts.updateAlert(alertItem: alertItem)
        let index = alerts.getIndexById(alertId: alertItem.id)

        if index > -1 && index < cellActions.count {
            if let actionContainer = cellActions[index] {
                actionContainer[ActionType.State]?.image = alerts.getStatus(forItem: index) == .Active
                        ? #imageLiteral(resourceName:"icPause")
                        : #imageLiteral(resourceName:"icPlay")
            }
        }

        tableView.reloadSections(IndexSet(integer: index), with: .automatic)
    }

    func deleteAlerts(ids: [Int]) {
        var idxForDelete = [Int]()
        for alertId in ids {
            let index = alerts.getIndexById(alertId: alertId)
            idxForDelete.append(index)

            cellActions.removeValue(forKey: alertId)
            cells.removeAll(where: { $0.item?.id == alertId })
        }

        ids.forEach({ alerts.removeItem(byId: $0) })

        tableView.performBatchUpdates({
            self.tableView.deleteSections(IndexSet(idxForDelete), with: .automatic)
        }, completion: {
            _ in
            self.checkOnRequirePlaceHolder()
        })
    }
}

// @MARK: manage cell actions
extension AlertsListView {
    func handleStateAction(elementIndex: Int) {
        alerts.reverseStatus(index: elementIndex)
        guard let alert = alerts.getCellItem(byRow: elementIndex) else {
            print("handleStateAction: item doesn't exists")
            return
        }
        presenter.updateAlertState(alert)
    }

    func handleEditAction(elementIndex: Int) {
        guard let alertModel = alerts.getCellItem(byRow: elementIndex) else {
            print("handleStateAction: item doesn't exists")
            return
        }
        presenter.editAlert(alertModel)
    }

    func handleRemoveAction(elementIndex: Int) {
        guard let alert = alerts.getCellItem(byRow: elementIndex) else {
            print("handleRemoveAction: item doesn't exists")
            return
        }
        presenter.deleteAlert(withId: alert.id)
    }
}

// @MARK: setup views
extension AlertsListView {
    func setupTutorialImg() {
        self.addSubview(tutorialImg)
        tutorialImg.anchorCenterSuperview()
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlertViewCell.self, forCellReuseIdentifier: kCellId)
    }
}