//
//  CHWatchlistViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWatchlistViewController: CHViewController, CHViewControllerProtocol {
    typealias ContentView = CHWatchlistView
    
    fileprivate var presenter: CHWatchlistPresenter!
    fileprivate enum Segues: String {
        case currencyDetails
        case manageCurrenciesList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TAB_WATCHLIST".localized
        
        presenter = CHWatchlistPresenter(collectionView: contentView.currenciesCollectionView,
                                             dataSource: CHWatchlistDataSource(),
                                                    api: TickerNetworkWorker())
        presenter.delegate = self
        presenter.fetchItems()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueType = Segues(rawValue: segue.identifier!)!
        switch segueType {
        case .currencyDetails:
            let currency = sender as! WatchlistCurrency
            let vc = segue.destination as! CurrencyChartViewController
            vc.setCurrencyPair(currency.tickerPair.code)
        case .manageCurrenciesList:
            break
        }
    }

}

// MARK: - CHWatchlistPresenterDelegate

extension CHWatchlistViewController: CHWatchlistPresenterDelegate {
    
    func presenter(_ presenter: CHWatchlistPresenter, didTouchCurrency currency: WatchlistCurrency) {
        performSegue(withIdentifier: Segues.currencyDetails.rawValue, sender: currency)
    }
    
}
