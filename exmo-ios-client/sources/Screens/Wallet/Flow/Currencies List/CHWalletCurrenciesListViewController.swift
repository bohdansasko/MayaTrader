//
//  CHWalletCurrenciesListViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 17/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

final class CHWalletCurrenciesListViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHWalletCurrenciesListView
    
    fileprivate lazy var currenciesSearchBar: CurrenciesListTabBar = {
        let currenciesSearchBar = CurrenciesListTabBar()
        return currenciesSearchBar
    }()
    
    fileprivate var presenter: CHWalletCurrenciesListPresenter!

    typealias OnCloseCompletion = (ExmoWallet?) -> ()
    var onClose: OnCloseCompletion?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPresenter()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchWallet()
    }
    
    override func shouldUseGlow() -> Bool {
        return false
    }
    
}

// MARK: - Setup views

private extension CHWalletCurrenciesListViewController {
    
    func setupUI() {
        setupNavigationBar()
//        showLoader()
//        if AppDelegate.isIPhone(model: .X) {
//            self.layoutConstraintHeaderHeight.constant = 95
//        }
    }
    
    func setupNavigationBar() {
        view.addSubview(currenciesSearchBar)
        currenciesSearchBar.callbackOnTouchDoneBtn = { [unowned self] in
            self.actClose()
        }
        currenciesSearchBar.searchBar.delegate = self
        contentView.searchBarContainer.addSubview(currenciesSearchBar)
        currenciesSearchBar.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
    func setupPresenter() {
        presenter = CHWalletCurrenciesListPresenter(tableView: contentView.tableView,
                                                    exmoAPI  : CHExmoAPI.shared,
                                                    dbManager: RealmDatabaseManager.shared)
    }
    
}

// MARK: - User interactions

private extension CHWalletCurrenciesListViewController {
    
    func actClose() {
        if var wallet = presenter.wallet {
            wallet.refreshOnFavDislikeBalances()
            onClose?(wallet)
        } else {
            onClose?(nil)
        }

        dismiss(animated: true)
    }
    
}

// MARK: - UISearchBarDelegate

extension CHWalletCurrenciesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filterBy(text: searchText)
    }
    
}
