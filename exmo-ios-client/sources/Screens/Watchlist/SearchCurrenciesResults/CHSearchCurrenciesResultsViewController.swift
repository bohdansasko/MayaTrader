//
//  SearchCurrenciesResultsViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSearchCurrenciesResultsViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHSearchCurrenciesResultsView
    
    fileprivate var items: [CHLiteCurrencyModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.set(dataSource: self, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCurrencies(by: "BTC_")
    }

    func fetchCurrencies(by string: String) {
        self.api.rx.getCurrencies(like: string, stocks: [.exmo], isExtended: false).subscribe(
            onNext: { [unowned self] currencies in
                self.items = currencies.map{ $0 }
                self.contentView.reloadList()
            }, onError: { err in
                print("\(#function)error: \(err.localizedDescription)")
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UISearchResultsUpdating

extension CHSearchCurrenciesResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? "<No string>"
        print(#function, searchText)
//        fetchCurrencies(by: searchText)
    }
    
}

extension CHSearchCurrenciesResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHSearchCurrencyResultCell.self, for: indexPath)
        return cell
    }
    
}

extension CHSearchCurrenciesResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let itemFormatter = CHLiteCurrencyFormatter(currency: item)
        let currencyCell = cell as! CHSearchCurrencyResultCell
        currencyCell.set(formatter: itemFormatter)
    }
    
}
