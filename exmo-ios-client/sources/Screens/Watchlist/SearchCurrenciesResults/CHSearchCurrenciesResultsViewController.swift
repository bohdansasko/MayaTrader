//
//  SearchCurrenciesResultsViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CHSearchCurrenciesResultsViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHSearchCurrenciesResultsView
    
    fileprivate var items: [CHLiteCurrencyModel] = []
    fileprivate var selectedItems: Set<CHLiteCurrencyModel> = []
    fileprivate var isSubscribedOnSearchBarText = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.set(dataSource: self, delegate: self)
    }

    func fetchCurrencies(by string: String?) {
        guard let string = string else { return }
        
        self.api.rx.getCurrencies(like: string, stocks: [.exmo], isExtended: false)
            .subscribe(
                onNext: { [unowned self] currencies in
                    self.items = currencies.map{ $0 }
                    self.contentView.reloadList()
                }, onError: { err in
                    print("\(#function)error: \(err.localizedDescription)")
                }
            ).disposed(by: self.disposeBag)
    }
}

// MARK: - UISearchResultsUpdating

extension CHSearchCurrenciesResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard !isSubscribedOnSearchBarText else { return }

        isSubscribedOnSearchBarText = true
        
        searchController.searchBar.rx.text
            .asDriver()
            .throttle(0.5, latest: true)
            .drive(onNext: { [unowned self] text in
                self.fetchCurrencies(by: text)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - UITableViewDataSource

extension CHSearchCurrenciesResultsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(class: CHSearchCurrencyResultCell.self, for: indexPath)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CHSearchCurrenciesResultsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let itemFormatter = CHLiteCurrencyFormatter(currency: item)
        let currencyCell = cell as! CHSearchCurrencyResultCell
        currencyCell.set(formatter: itemFormatter)
        currencyCell.set(isSelected: selectedItems.contains(item))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let item = items[indexPath.row]
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CHSearchCurrencyResultCell else { return }
        cell.set(isSelected: selectedItems.contains(item))
    }
    
}
