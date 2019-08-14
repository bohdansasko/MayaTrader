//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class WalletSegueBlock: SegueBlock {
    private(set) var wallet: ExmoWallet!
    
    init(dataModel: ExmoWallet?) {
        wallet = dataModel
    }
}

final class CHWalletCurrenciesListPresenter: NSObject {
    fileprivate weak var tableView: UITableView!
    
    fileprivate let networkAPI: CHExmoAPI
    fileprivate let dbManager : OperationsDatabaseProtocol
    
    fileprivate let disposeBag = DisposeBag()
    
    var wallet: ExmoWallet? {
        didSet {
            if let w = wallet {
                tableView.isScrollEnabled = w.favBalances.count > 0
            }
            
//            showPlaceholderIfRequired()
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, networkAPI: CHExmoAPI, database: OperationsDatabaseProtocol) {
        self.tableView  = tableView
        self.networkAPI = networkAPI
        self.dbManager  = database
        
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

// MARK: - Network

extension CHWalletCurrenciesListPresenter  {
    
    func fetchWallet() {
        let walletRequest = networkAPI.rx.getWallet()
        walletRequest.subscribe(onSuccess: { [weak self] aWallet in
            guard let `self` = self else { return }
            self.refreshWallet(aWallet)
        }, onError: { err in
            print(err.localizedDescription)
        }).disposed(by: self.disposeBag)
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

// MARK: IWalletNetworkWorkerDelegate
extension CHWalletCurrenciesListPresenter {
    
    func refreshWallet(_ w: ExmoWallet) {
        guard let cachedWallet = dbManager.object(type: ExmoWalletObject.self, key: "") else {
            print("can't read object ExmoWalletObject from db")
            dbManager.performTransaction {
                self.dbManager.add(data: w.managedObject(), update: true)
            }
            self.wallet = w
            return
        }
        cachedWallet.balances.forEach({ [unowned self] cachedCurrency in
            guard let iCurrency = w.balances.first(where: { $0.code == cachedCurrency.code }) else { return }
            self.dbManager.performTransaction {
                cachedCurrency.balance = iCurrency.balance
                cachedCurrency.countInOrders = iCurrency.countInOrders
            }
        })
        self.wallet = ExmoWallet(managedObject: cachedWallet)
    }
    
}
