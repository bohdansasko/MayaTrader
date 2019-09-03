//
//  CreateAlertViewController+TableDelegate+TableDatasource.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 12/1/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

// MARK: - UITableViewDataSource

extension CreateAlertViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return form.cellItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = cells[indexPath] {
            return cell
        }
        
        var cell: UITableViewCell
        if let cellType = form.cellItems[indexPath.section].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath)
            cells[indexPath] = cell
        } else {
            fatalError("cell is required")
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CreateAlertViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FormUpdatable else { return }
        cell.update(item: form.cellItems[indexPath.section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return form.cellItems[indexPath.section].uiProperties.height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return form.cellItems[section].uiProperties.spacingBetweenRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if form.cellItems[indexPath.section].uiProperties.cellType == .currencyDetails {
            self.performSegue(withIdentifier: Segues.selectCurrency.rawValue)
        }
    }
    
}
