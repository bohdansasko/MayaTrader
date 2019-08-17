//
//  CHSearchCurrenciesResultsView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSearchCurrenciesResultsView: UIView {
    
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }

}

// MARK: - Setup

private extension CHSearchCurrenciesResultsView {
    
    func setupUI() {
        tableView.register(nib: CHSearchCurrencyResultCell.self)
    }
    
}

// MARK: - Set

extension CHSearchCurrenciesResultsView {
    
    func set(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
}

// MARK: - Help

extension CHSearchCurrenciesResultsView {
    
    func reloadList() {
        tableView.reloadData()
    }
    
}
