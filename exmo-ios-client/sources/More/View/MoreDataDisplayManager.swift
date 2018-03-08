//
//  MoreDataDisplayManager.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/28/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class MoreDataDisplayManager: NSObject {
    private var dataProvider: MoreDisplayModel!
    private var tableView: UITableView!
    
    var interactor: MoreInteractorInput!

    override init() {
        super.init()
        dataProvider = MoreDisplayModel()
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
    
    func getMenuItemName(byRow: Int) -> String {
        return dataProvider.getMenuItemName(byRow: byRow)
    }

    func getMenuItemSegueIdentifier(byRow: Int) -> String {
        return dataProvider.getMenuItemSegueIdentifier(byRow: byRow)
    }
}

extension MoreDataDisplayManager: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.getCountMenuItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.MoreMenuItem.rawValue, for: indexPath) as! MenuItemTableViewCell
        menuItem.setTitleLabel(text: self.dataProvider.getMenuItemName(byRow: indexPath.row))
        return menuItem
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if dataProvider.isSegueItem(byRow: row) {
            let segueIdentifier = dataProvider.getMenuItemSegueIdentifier(byRow: row)
            interactor.onDidSelectMenuItem(segueIdentifier: segueIdentifier)
        } else {
            dataProvider.doAction(itemIndex: row)
        }
    }
}
