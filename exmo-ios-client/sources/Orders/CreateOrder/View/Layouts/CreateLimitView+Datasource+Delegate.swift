//
//  CreateLimitView+Datasource+Delegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// @MARK: UITableViewDataSource
extension CreateOrderLimitView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfRowsInTab()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = nil
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section+1 == numberOfRowsInTab() ? 45 : 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cells[indexPath] != nil {
            return cells[indexPath]! ?? UITableViewCell()
        }
        switch (layoutType) {
        case .Limit: cells[indexPath] = getLimitCell(cellForRowAt: indexPath)
        case .InstantOnAmount: cells[indexPath] = getInstantOnAmountCell(cellForRowAt: indexPath)
        case .InstantOnSum: cells[indexPath] = getInstantOnSumCell(cellForRowAt: indexPath)
        }
        return cells[indexPath]!!
    }
}

// @MARK: UITableViewDelegate
extension CreateOrderLimitView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == getSelectCurrencyIndexCell() {
            output.openCurrencySearchVC()
        }
    }
}
