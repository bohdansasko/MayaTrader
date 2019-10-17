//
// Created by Bogdan Sasko on 3/8/18.
// Copyright (c) 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol CHWalletCurrenciesPresenterDelegate: class {
    func walletCurrenciesListPresenter(_ presenter: CHWalletCurrenciesPresenter, onWalletRefreshed wallet: ExmoWallet?, balance walletBalance: CHWalletBalance?)
}

final class CHWalletCurrenciesPresenter: NSObject {
    fileprivate weak var tableView: UITableView!
    
    fileprivate let exmoAPI  : CHExmoAPI
    fileprivate let vinsoAPI : VinsoAPI
    fileprivate let dbManager: OperationsDatabaseProtocol
    
    fileprivate let disposeBag = DisposeBag()
    
    weak var delegate: CHWalletCurrenciesPresenterDelegate?
    
    fileprivate var walletBalance: CHWalletBalance?
    
    var wallet: ExmoWallet? {
        didSet {
            if let w = wallet {
                tableView.isScrollEnabled = w.favBalances.count > 0
            }
            delegate?.walletCurrenciesListPresenter(self, onWalletRefreshed: self.wallet, balance: walletBalance)
            tableView.reloadData()
        }
    }
    
    init(tableView: UITableView, exmoAPI: CHExmoAPI, vinsoAPI: VinsoAPI, database: OperationsDatabaseProtocol) {
        self.tableView = tableView
        self.exmoAPI   = exmoAPI
        self.vinsoAPI  = vinsoAPI
        self.dbManager = database
        
        super.init()
        
        setupTableView()
    }

}

// MARK: - Setup

private extension CHWalletCurrenciesPresenter  {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(nib: CHWalletCurrencyCell.self)
    }
    
}

// MARK: - Network

extension CHWalletCurrenciesPresenter  {
    
    func fetchWallet() {
        guard let dbWallet = self.dbManager.object(type: ExmoWalletObject.self, key: "") else {
            self.walletBalance = nil
            self.wallet = nil
            return
        }
        
        let w = ExmoWallet(managedObject: dbWallet)
        let info = w.balances.reduce(into: [String: Double](), { r, currency in
            if currency.balance > 0 {
                r[currency.code] = currency.balance
            }
        })
        
        vinsoAPI.rx.getBalance(in: ["BTC", "USD"], info: info, at: .exmo)
            .subscribe(
                onSuccess: { [weak self] balance in
                    guard let `self` = self else { return }
                    self.walletBalance = balance
                    self.wallet = w
                }, onError: { err in
                    log.error(err.localizedDescription)
                }
            ).disposed(by: disposeBag)
    }
    
    func saveWallet(_ wallet: ExmoWallet) {
        dbManager.add(data: wallet.managedObject(), update: true)
    }
    
}

// MARK: - UITableViewDataSource

extension CHWalletCurrenciesPresenter: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallet?.favBalances.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHWalletCurrencyCell.self, for: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CHWalletCurrenciesPresenter: UITableViewDelegate  {
    
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
