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
        case state
        case edit
        case delete
    }

    weak var presenter: AlertsViewOutput!
    lazy var alerts = AlertsModel()
    var cells: [AlertViewCell] = []
    var cellActions: [Int: [ActionType: UIContextualAction] ] = [:]
    let kCellId = "alertCellId"

    var tutorialImg: TutorialImage = {
        let img = TutorialImage()
//        img.imageName = "imgTutorialAlert"
        img.contentMode = .scaleAspectFit
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

    let quantityPairsAllowsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.getExo2Font(fontType: .medium, fontSize: 14)
        label.text = "0/0"
        return label
    }()

    var maxPairs: LimitObjects? {
        didSet {
            guard let mp = maxPairs else { return }
            quantityPairsAllowsLabel.text = mp.asString
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(quantityPairsAllowsLabel)
        quantityPairsAllowsLabel.anchor(
                self.topAnchor, left: self.leftAnchor,
                bottom: nil, right: self.rightAnchor,
                topConstant: 0, leftConstant: 0,
                bottomConstant: 0, rightConstant: 20,
                widthConstant: 0, heightConstant: 20)

        setupTutorialImg()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder aDecoder: NSCoder) hasn't implementation of")
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

// MARK: append/update/delete cell
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
                actionContainer[ActionType.state]?.image = alerts.getStatus(forItem: index) == .active
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

// MARK: manage cell actions
extension AlertsListView {
    func handleStateAction(elementIndex: Int) {
        alerts.reverseStatus(index: elementIndex)
        guard let alert = alerts.getCellItem(byRow: elementIndex) else {
            log.error("handleStateAction: item doesn't exists")
            return
        }
        presenter.updateAlertState(alert)
    }

    func handleEditAction(elementIndex: Int) {
        guard let alertModel = alerts.getCellItem(byRow: elementIndex) else {
            log.error("handleStateAction: item doesn't exists")
            return
        }
        presenter.editAlert(alertModel)
    }

    func handleRemoveAction(elementIndex: Int) {
        guard let alert = alerts.getCellItem(byRow: elementIndex) else {
            log.error("handleRemoveAction: item doesn't exists")
            return
        }
        presenter.deleteAlert(withId: alert.id)
    }
}

// MARK: setup views
extension AlertsListView {
    func setupTutorialImg() {
        self.addSubview(tutorialImg)
        tutorialImg.anchor(topAnchor, left: leftAnchor,
                           bottom: bottomAnchor, right: rightAnchor,
                           topConstant: 10, leftConstant: 10,
                           bottomConstant: 20, rightConstant: 10,
                           widthConstant: 0, heightConstant: 0)
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.anchor(
                quantityPairsAllowsLabel.bottomAnchor, left: self.leftAnchor,
                bottom: self.bottomAnchor, right: self.rightAnchor,
                topConstant: 0, leftConstant: 0,
                bottomConstant: 0, rightConstant: 0,
                widthConstant: 0, heightConstant: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlertViewCell.self, forCellReuseIdentifier: kCellId)
    }
}
