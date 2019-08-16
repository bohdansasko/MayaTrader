//
//  WalletCurrenciesListWalletCurrenciesListInteractor.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class CHWalletCurrenciesListView: UIView {
    @IBOutlet private(set) weak var searchBarContainer: UIView!
    @IBOutlet private(set) weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        setupUI()
    }
    
}

// MARK: - Setup

private extension CHWalletCurrenciesListView {
    
    func setupUI() {
        searchBarContainer.backgroundColor = .clear
        tableView.tableFooterView = UIView()
    }
    
}
