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
    
    // MARK: - Private params
    
    fileprivate var presenter: CHSearchCurrenciesResultsPresenter!
    fileprivate var sortBy   : CHExchangeSortBy = .pair
    fileprivate var isSubscribedOnSearchBarText = false
    
    // MARK: - Input params
    
    var selectionMode: CHSelectionCurrenciesMode! {
        didSet { assert(!self.isViewLoaded) }
    }
    
    var onClose: ((CHLiteCurrencyModel) -> Void)?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(selectionMode != nil, "required")
        
        setupPresenter()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        isSubscribedOnSearchBarText = false
        disposeBag = DisposeBag()
        
        presenter.saveChanges()
    }
    
    func set(sortBy: CHExchangeSortBy) {
        self.sortBy = sortBy
        self.presenter.fetchCurrencies(sortBy: self.sortBy)
    }
    
}

// MARK: Setup methods

private extension CHSearchCurrenciesResultsViewController {

    func setupPresenter() {
        let dataSource = CHSearchCurrenciesResultsDataSource(dbManager: dbManager)
        presenter = CHSearchCurrenciesResultsPresenter(currenciesListView: contentView.tableView,
                                                       dataSource        : dataSource,
                                                       vinsoAPI          : vinsoAPI,
                                                       selectionMode     : selectionMode
        )
        presenter.delegate = self
        contentView.set(dataSource: dataSource, delegate: presenter)
    }
    
}

// MARK: - UISearchResultsUpdating

extension CHSearchCurrenciesResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard !isSubscribedOnSearchBarText else { return }

        isSubscribedOnSearchBarText = true
        
        searchController.searchBar.rx.text
            .asDriver()
            .throttle(1.0, latest: true)
            .distinctUntilChanged()
            .drive(onNext: { [weak self] text in
                guard let `self` = self else { return }
                self.presenter.fetchCurrencies(by: text, sortBy: self.sortBy)
            })
            .disposed(by: self.disposeBag)
    }
    
}

// MARK: - CHSearchCurrenciesResultsPresenterDelegate

extension CHSearchCurrenciesResultsViewController: CHSearchCurrenciesResultsPresenterDelegate {
    
    func searchCurrenciesResultsPresenter(_ presenter: CHSearchCurrenciesResultsPresenter, onError error: Error) {
        handleError(error)
    }
    
    func searchCurrenciesResultsPresenter(_ presenter: CHSearchCurrenciesResultsPresenter, didSelect currency: CHLiteCurrencyModel) {
        if selectionMode == .currency {
            onClose?(currency)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
