//
//  SearchCurrenciesResultsViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSearchCurrenciesResultsViewController: CHViewController, CHViewControllerProtocol {
    typealias ContentView = CHSearchCurrenciesResultsView
    
    fileprivate var items: [TickerCurrencyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.set(dataSource: self, delegate: self)
        self.fetchCurrencies()
        
    }

    func fetchCurrencies() {
        let request = self.api.rx.getCurrencies(by: .exmo, selectedCurrencies: ["BTC_USD", "LTC_EUR"])
        request.subscribe(onSuccess: { arr in
            //
        }, onError: { err in
            print(err)
        }).disposed(by: self.disposeBag)
    }
    
}

// MARK: - UISearchResultsUpdating

extension CHSearchCurrenciesResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? "<No string>"
        print(#function, searchText)
    }
    
}

extension CHSearchCurrenciesResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHSearchCurrencyResultCell.self, for: indexPath)
        return cell
    }
    
}

extension CHSearchCurrenciesResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let item = items[indexPath.row]
//        let currencyCell = cell as! CHSearchCurrencyResultCell
//        currencyCell.set(model: item)
        
    }
    
}
