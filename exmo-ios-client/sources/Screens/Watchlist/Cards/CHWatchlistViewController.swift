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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TAB_WATCHLIST".localized
        
        presenter = CHWatchlistPresenter(collectionView: contentView.currenciesCollectionView,
                                             dataSource: CHWatchlistDataSource(),
                                               vinsoAPI: vinsoAPI,
                                              dbManager: dbManager)
        presenter.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.rx.showLoadingView(request: self.presenter.fetchItems())
        }
    }

    // MARK: - Navigation
    
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

// MARK: - Prepare view controller for segue

extension CHWatchlistViewController {
    
    func prepareCurrencyChartViewController(for segue: UIStoryboardSegue, sender: Any?) {
        let currency = sender as! WatchlistCurrency
        let vc = segue.destination as! CurrencyChartViewController
        vc.setCurrencyPair(currency.tickerPair.code)
    }
    
}

// MARK: - Actions

private extension CHWatchlistViewController {
    
    @IBAction func actManageCurrencies(_ sender: Any) {
        performSegue(withIdentifier: Segues.manageCurrenciesList.rawValue, sender: nil)
    }
    
}

// MARK: - CHWatchlistPresenterDelegate

extension CHWatchlistViewController: CHWatchlistPresenterDelegate {
    
    func presenter(_ presenter: CHWatchlistPresenter, didUpdatedCurrenciesList currencies: [CHLiteCurrencyModel]) {
        contentView.isTutorialStubVisible = currencies.isEmpty
    }
    
    func presenter(_ presenter: CHWatchlistPresenter, didTouchCurrency currency: CHLiteCurrencyModel) {
        performSegue(withIdentifier: Segues.currencyDetails.rawValue, sender: currency)
    }
    
    func presenter(_ presenter: CHWatchlistPresenter, onError error: Error) {
        handleError(error)
    }
    
}
