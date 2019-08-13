//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class WalletSegueBlock: SegueBlock {
    private(set) var wallet: ExmoWallet!
    
    init(dataModel: ExmoWallet?) {
        wallet = dataModel
    }
}

final class CHWalletCurrenciesListPresenter: NSObject {
    fileprivate weak var tableView: UITableView!
    
    var wallet: ExmoWallet? {
        didSet {
            if let w = wallet {
                tableView.isScrollEnabled = w.favBalances.count > 0
            }
            
//            showPlaceholderIfRequired()
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        setupTableView()
    }

    func getWalletModelAsSegueBlock() -> SegueBlock? {
        return WalletSegueBlock(dataModel: wallet)
    }
    
}

// MARK: - Setup

private extension CHWalletCurrenciesListPresenter  {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib: CHWalletCurrencyCell.self)
    }
    
}

// MARK: - UITableViewDataSource

extension CHWalletCurrenciesListPresenter: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet?.favBalances.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHWalletCurrencyCell.self, for: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CHWalletCurrenciesListPresenter: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return CHWalletCurrencyHeaderView.loadViewFromNib()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let walletCell = cell as? CHWalletCurrencyCell,
            let model = wallet?.favBalances[indexPath.row] else {
                return
        }
        walletCell.set(model)
        walletCell.backgroundColor = (indexPath.row + 1) % 2 == 0 ? .dark : .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
}
