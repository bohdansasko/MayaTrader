//
//  CHExchangesViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

struct CHExchangeModel {
    var icon: UIImage
    var name: String
}

final class CHExchangesViewController: CHViewController, CHViewControllerProtocol {
    typealias ContentView = CHExchangesView
    
    fileprivate var presenter: CHExchangePresenter!
    
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

