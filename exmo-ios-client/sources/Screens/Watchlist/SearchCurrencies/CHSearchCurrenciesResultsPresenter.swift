//
//  CHSearchCurrenciesResultsPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/19/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

final class CHSearchCurrenciesResultsPresenter: NSObject {
    fileprivate let currenciesListView: UITableView
    fileprivate let dataSource        : CHSearchCurrenciesResultsDataSource
    fileprivate let vinsoAPI          : VinsoAPI
    fileprivate let disposeBag       = DisposeBag()
    
    fileprivate var likeString: String?
    fileprivate let kCurrenciesFetchLimit = 30
    fileprivate var isDownloadedAllItems: Bool = false
    
    init(currenciesListView: UITableView, dataSource: CHSearchCurrenciesResultsDataSource, vinsoAPI: VinsoAPI) {
        self.currenciesListView = currenciesListView
        self.dataSource         = dataSource
        self.vinsoAPI           = vinsoAPI
        
        super.init()
    }
    
}

// MARK: - Help methods

extension CHSearchCurrenciesResultsPresenter {
    
    func fetchCurrencies(by string: String?) {
        guard let likeString = string?.trim(), !likeString.isEmpty else { return }

        self.likeString           = likeString
        self.isDownloadedAllItems = false
        
        self.vinsoAPI.rx.getCurrencies(like: likeString, limit: kCurrenciesFetchLimit, offset: 0)
            .subscribe(
                onNext: { [unowned self] currencies in
                    self.dataSource.set(currencies)
                    self.currenciesListView.reloadData()
                }, onError: { err in
                    print("\(#function)error: \(err.localizedDescription)")
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchNextCurrenciesPage() {
        if isDownloadedAllItems { return }
        
        guard let likeString = self.likeString else { return }
        
        self.vinsoAPI.rx.getCurrencies(like: likeString, limit: kCurrenciesFetchLimit, offset: dataSource.items.count)
            .subscribe(
                onNext: { [unowned self] currencies in
                    self.isDownloadedAllItems = currencies.isEmpty
                    if self.isDownloadedAllItems { return }
                    
                    let offset = self.dataSource.items.count
                    let lastIndex = offset + currencies.count
                    
                    self.dataSource.append(currencies)
                    DispatchQueue.main.async {
                        self.currenciesListView.beginUpdates()
                        let rows = (offset..<lastIndex).map{ IndexPath(row: $0, section: 0) }
                        self.currenciesListView.insertRows(at: rows, with: .none)
                        self.currenciesListView.endUpdates()
                    }
                }, onError: { err in
                    print("\(#function)error: \(err.localizedDescription)")
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchItemsIfNeeded(indexPath: IndexPath) {
        let limitIndex = indexPath.row + 3
        if limitIndex > dataSource.items.count {
            fetchNextCurrenciesPage()
        }
    }
    
    func resetList() {
        isDownloadedAllItems = false
        likeString = nil
        dataSource.reset()
    }
    
}

// MARK: - UITableViewDelegate

extension CHSearchCurrenciesResultsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = dataSource.item(for: indexPath.row)
        let itemFormatter = CHLiteCurrencyFormatter(currency: item)
        let currencyCell = cell as! CHSearchCurrencyResultCell
        currencyCell.set(formatter: itemFormatter)
        
        let isSelected = dataSource.isItem(selected: item)
        currencyCell.set(isSelected: isSelected)
        
        fetchItemsIfNeeded(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let item = dataSource.item(for: indexPath.row)
        
        if dataSource.isItem(selected: item) {
            dataSource.remove(selected: item)
        } else {
            dataSource.add(selected: item)
        }

        guard let currencyCell = tableView.cellForRow(at: indexPath) as? CHSearchCurrencyResultCell else {
            assertionFailure("must be casted")
            return
        }
        let isSelected = dataSource.isItem(selected: item)
        currencyCell.set(isSelected: isSelected)
    }
    
}
