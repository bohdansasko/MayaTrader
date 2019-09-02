//
//  CHSearchCurrenciesResultsPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/19/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

protocol CHSearchCurrenciesResultsPresenterDelegate: class {
    func searchCurrenciesResultsPresenter(_ presenter: CHSearchCurrenciesResultsPresenter, onError error: Error)
}

final class CHSearchCurrenciesResultsPresenter: NSObject {
    
    // MARK: Private
    
    fileprivate let currenciesListView: UITableView
    fileprivate let dataSource        : CHSearchCurrenciesResultsDataSource
    fileprivate let vinsoAPI          : VinsoAPI
    fileprivate let disposeBag       = DisposeBag()
    
    fileprivate(set) var likeString     : String?
    fileprivate let kCurrenciesFetchLimit = 30
    fileprivate var isDownloadedAllItems: Bool = false
    fileprivate var sortBy              : CHExchangeSortBy = .pair
    
    // MARK: Public
    
    var delegate: CHSearchCurrenciesResultsPresenterDelegate?
    
    // MARK: - View life cycle
    
    init(currenciesListView: UITableView, dataSource: CHSearchCurrenciesResultsDataSource, vinsoAPI: VinsoAPI) {
        self.currenciesListView = currenciesListView
        self.dataSource         = dataSource
        self.vinsoAPI           = vinsoAPI
        
        super.init()
        
        dataSource.fetchFavouriteCurrencies()
    }
    
}

// MARK: - Help methods

extension CHSearchCurrenciesResultsPresenter {
    
    func fetchCurrencies(sortBy: CHExchangeSortBy) {
        fetchCurrencies(by: likeString, sortBy: sortBy)
    }
    
    func fetchCurrencies(by string: String?, sortBy: CHExchangeSortBy) {
        guard let likeString = string?.trim(), !likeString.isEmpty else { return }
        
        self.likeString           = likeString
        self.isDownloadedAllItems = false
        self.sortBy               = sortBy
        
        self.vinsoAPI.rx.getCurrencies(like: likeString, sortBy: sortBy, order: .descending, limit: kCurrenciesFetchLimit, offset: 0)
            .subscribe(
                onSuccess: { [unowned self] currencies in
                    self.dataSource.set(currencies)
                    self.currenciesListView.reloadData()
                },
                onError: { [weak self] err in
                    guard let `self` = self else { return }
                    self.delegate?.searchCurrenciesResultsPresenter(self, onError: err)
                }
            )
            .disposed(by: self.disposeBag)
    }
    
    func fetchNextCurrenciesPage() {
        if isDownloadedAllItems { return }
        
        guard let likeString = self.likeString else { return }
        
        self.vinsoAPI.rx.getCurrencies(like: likeString, sortBy: sortBy, order: .descending, limit: kCurrenciesFetchLimit, offset: dataSource.items.count)
            .subscribe(
                onSuccess: { [unowned self] currencies in
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
                },
                onError: { [weak self] err in
                    guard let `self` = self else { return }
                    self.delegate?.searchCurrenciesResultsPresenter(self, onError: err)
                }
            )
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
        dataSource.set([])
    }
    
    func saveChanges() {
        dataSource.cacheToDatabase()
    }
    
    func handleTapOnFavourite(by indexPath: IndexPath) {
        guard let currencyCell = currenciesListView.cellForRow(at: indexPath) as? CHSearchCurrencyResultCell else {
            assertionFailure("must be casted")
            return
        }

        let item           = dataSource.item(for: indexPath.row)
        let isItemWasSelected = dataSource.isItem(selected: item)
        
        if isItemWasSelected {
            dataSource.remove(selected: item)
        } else {
            dataSource.add(selected: item)
        }
        currencyCell.set(isSelected: !isItemWasSelected)
    }
    
}

// MARK: - UITableViewDelegate

extension CHSearchCurrenciesResultsPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = dataSource.item(for: indexPath.row)
        let itemFormatter = CHLiteCurrencyFormatter(
                currency: item,
                addLabels: false,
                isFavourite: dataSource.isItem(selected: item))

        let currencyCell = cell as! CHSearchCurrencyResultCell
        currencyCell.set(indexPath: indexPath, formatter: itemFormatter)
        
        let isSelected = dataSource.isItem(selected: item)
        currencyCell.set(isSelected: isSelected)
        currencyCell.delegate = self
        
        fetchItemsIfNeeded(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        handleTapOnFavourite(by: indexPath)
    }

}

// MARK: - CHSearchCurrencyResultCellDelegate

extension CHSearchCurrenciesResultsPresenter: CHSearchCurrencyResultCellDelegate {
    
    func searchCurrencyResultCell(_ cell: CHSearchCurrencyResultCell, didTapFavouriteAt indexPath: IndexPath) {
        handleTapOnFavourite(by: indexPath)
    }
    
}
