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
    //
    // @MARK: outlets
    //
    private var dataProvider: MoreDisplayModel!
    private var tableView: UITableView!

    var viewOutput: MoreViewOutput!

    //
    // @MARK: public methods
    //
    override init() {
        super.init()
        dataProvider = MoreDisplayModel()
    }
    
    func setTableView(tableView: UITableView!) {
        self.tableView = tableView
        
        let cellNib = UINib(nibName: "MoreOptionsMenuCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: TableCellIdentifiers.MoreMenuItem.rawValue)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.updateInfo()
    }
    
    func getCountMenuItems() -> Int {
        return dataProvider.getCountMenuItems()
    }
    
    func getMenuItemName(byRow: Int) -> String {
        return dataProvider.getMenuItemTitle(byRow: byRow)
    }

    func getMenuItemSegueIdentifier(byRow: Int) -> String {
        return dataProvider.getMenuItemSegueIdentifier(byRow: byRow)
    }
    
    //
    // @MARK: selectors
    //
    @objc func updateInfo() {
        dataProvider.update()
        self.tableView.reloadData()
    }
}

extension MoreDataDisplayManager: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataProvider.getCountMenuItems()
    }
    
}


extension MoreDataDisplayManager: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = self.tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.MoreMenuItem.rawValue, for: indexPath) as! MoreOptionsMenuCell
        menuItem.setContentData(itemData: self.dataProvider.getMenuItem(byRow: indexPath.row))
        return menuItem
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if dataProvider.isSegueItem(byRow: row) {
            let segueIdentifier = dataProvider.getMenuItemSegueIdentifier(byRow: row)
            viewOutput.onDidSelectMenuItem(segueIdentifier: segueIdentifier)
        } else {
            dataProvider.doAction(itemIndex: row)
        }
    }
    
}
