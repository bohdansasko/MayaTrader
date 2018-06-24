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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataProvider.getCountMenuItems()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}


extension MoreDataDisplayManager: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = self.tableView.dequeueReusableCell(withIdentifier: TableCellIdentifiers.MoreMenuItem.rawValue, for: indexPath) as! MoreOptionsMenuCell
        menuItem.setContentData(itemData: self.dataProvider.getMenuItem(byRow: indexPath.section))
        return menuItem
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.section
        if dataProvider.isSegueItem(byRow: row) {
            let segueIdentifier = dataProvider.getMenuItemSegueIdentifier(byRow: row)
            viewOutput.onDidSelectMenuItem(segueIdentifier: segueIdentifier)
        } else {
            dataProvider.doAction(itemIndex: row)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 30, y: 0, width: tableView.frame.size.width, height: 2))
        footerView.backgroundColor = UIColor.clear
        
        let separatorLineWidth = footerView.frame.size.width - 60
        
        let separatorLine = UIView(frame: CGRect(x: 30, y: 0, width: separatorLineWidth, height: 2.0))
        separatorLine.backgroundColor = UIColor(red: 53/255.0, green: 51/255.0, blue: 67/255.0, alpha: 1.0)
        footerView.addSubview(separatorLine)
        separatorLine.bottomAnchor.constraint(equalTo: footerView.layoutMarginsGuide.bottomAnchor)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2.0
    }
    
}
