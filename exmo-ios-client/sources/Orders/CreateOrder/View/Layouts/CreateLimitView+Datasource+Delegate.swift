//
//  CreateLimitView+Datasource+Delegate.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/25/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// MARK: UITableViewDataSource
extension CreateOrderLimitView: UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return form.tabs[layoutType.rawValue].cellItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return form.tabs[layoutType.rawValue].cellItems[section].uiProperties.spacingBetweenRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = nil
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return form.tabs[layoutType.rawValue].cellItems[indexPath.section].uiProperties.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = cells[indexPath] {
            return cell
        }
        
        var cell: UITableViewCell
        if let cellType = form.tabs[layoutType.rawValue].cellItems[indexPath.section].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath)
            cells[indexPath] = cell
        } else {
            cell = UITableViewCell()
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension CreateOrderLimitView: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FormUpdatable else { return }
        cell.update(item: form.tabs[layoutType.rawValue].cellItems[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if form.tabs[layoutType.rawValue].cellItems[indexPath.section].uiProperties.cellType == .CurrencyDetails {
            output.openCurrencySearchVC()
        }
    }
}
