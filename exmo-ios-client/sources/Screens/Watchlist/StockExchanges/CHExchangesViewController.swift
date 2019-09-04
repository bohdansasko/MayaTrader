//
//  CHExchangesViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

struct CHExchangeModel {
    var icon: UIImage
    var name: String
}

enum CHSelectionCurrenciesMode {
    case currencies // can select many currencies
    case currency   // can select a currency
}

final class CHExchangesViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHExchangesView
    
    // MARK: - Private params
    
    fileprivate var presenter: CHExchangePresenter!
    
    // MARK: - Input params
    
    var selectionMode: CHSelectionCurrenciesMode = .currencies
    var onClose: ((CHLiteCurrencyModel) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        setupNavigationBar()
        setupPresenter()
    }

}

// MARK: - Setup methods

private extension CHExchangesViewController {
    
    func setupNavigationBar() {
        navigationItem.titleView = nil
        navigationItem.title = "SCREEN_CURRENCIES_GROUP_TITLE".localized
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = contentView.searchController
    }
    
    func setupPresenter() {
        let networkAPI = TickerNetworkWorker()
        let dataSource = CHExchangeDataSource()
        
        presenter = CHExchangePresenter(api: networkAPI, dataSource: dataSource)
        presenter.delegate = self
        
        contentView.setList(dataSource: dataSource, delegate: presenter)
        contentView.setSearchBar(delegate: self)
        contentView.set(completionOnClose: { [unowned self] c in
            self.onClose?(c)
            self.close()
        })
        contentView.searchResultsController.selectionMode = selectionMode
    }
    
}

// MARK: - Actions

private extension CHExchangesViewController {
    
    @IBAction func actClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - CHExchangePresenterDelegate

extension CHExchangesViewController: CHExchangePresenterDelegate {
    
    func exchangePresenter(_ presenter: CHExchangePresenter, didTouchExchange exchange: CHExchangeModel) {
        print(#function, exchange.name)
        contentView.set(searchText: exchange.name + " ")
    }

}

// MARK: - CHExchangePresenterDelegate

extension CHExchangesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let sortBy = CHExchangeSortBy(rawValue: selectedScope)!
        contentView.searchResultsController.set(sortBy: sortBy)
    }
    
}

