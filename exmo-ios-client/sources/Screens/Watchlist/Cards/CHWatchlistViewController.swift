//
//  CHWatchlistViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWatchlistViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHWatchlistView
    
    fileprivate enum Segues: String {
        case currencyDetails
        case manageCurrenciesList
    }
    
    fileprivate var presenter: CHWatchlistPresenter!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TAB_WATCHLIST".localized
        setupPresenter()
        fetchCurrencies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.runIntervalCurrenciesRefreshing()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.stopIntervalCurrenciesRefreshing()
    }
    
    // MARK: - 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueType = Segues(rawValue: segue.identifier!)!
        switch segueType {
        case .currencyDetails:
            self.prepareCurrencyChartViewController(for: segue, sender: sender)
        case .manageCurrenciesList:
            break
        }
    }

}

// MARK: - Setup

private extension CHWatchlistViewController {
    
    func setupPresenter() {
        presenter = CHWatchlistPresenter(collectionView: contentView.currenciesCollectionView,
                                             dataSource: CHWatchlistDataSource(),
                                               vinsoAPI: vinsoAPI,
                                              dbManager: dbManager)
        presenter.delegate = self
    }
        
}
    
// MARK: - Prepare view controller for segue

extension CHWatchlistViewController {
    
    func prepareCurrencyChartViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let currency = sender as! CHLiteCurrencyModel
        let vc = segue.destination as! CHCurrencyChartViewController
        vc.currency = currency
    }
    
}

// MARK: - Actions

private extension CHWatchlistViewController {
    
    @IBAction func actManageCurrencies(_ sender: Any) {
        performSegue(withIdentifier: Segues.manageCurrenciesList.rawValue, sender: nil)
    }
    
}

// MARK: - API

private extension CHWatchlistViewController {
 
    func fetchCurrencies() {
        let request = presenter.fetchItems()
        rx.showLoadingView(request: request)
    }
    
}

// MARK: - CHWatchlistPresenterDelegate

extension CHWatchlistViewController: CHWatchlistPresenterDelegate {
    
    func presenter(_ presenter: CHWatchlistPresenter, didUpdatedCurrenciesList currencies: [CHLiteCurrencyModel]) {
        contentView.setTutorialVisible(isUserAuthorizedToExmo: exmoAPI.isAuthorized, hasContent: !currencies.isEmpty)
    }
    
    func presenter(_ presenter: CHWatchlistPresenter, didTouchCurrency currency: CHLiteCurrencyModel) {
        performSegue(withIdentifier: Segues.currencyDetails.rawValue, sender: currency)
    }
    
    func presenter(_ presenter: CHWatchlistPresenter, onError error: Error) {
        handleError(error)
    }
    
}
