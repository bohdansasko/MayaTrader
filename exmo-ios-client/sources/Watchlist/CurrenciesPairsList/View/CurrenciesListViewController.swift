//
//  CurrenciesListViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

protocol CurrenciesListViewControllerInput: class {
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency])
}

protocol CurrenciesListViewControllerOutput: class {
    func viewIsReady()
    func viewWillDisappear()
    func handleTouchFavBtn(datasourceItem: Any?, isSelected: Bool)
}

class CurrenciesListViewController: ExmoUIViewController {
    var output: CurrenciesListViewControllerOutput!
    
    var tabBar: CurrenciesListTabBar = {
        let tabBar = CurrenciesListTabBar()
        return tabBar
    }()
    
    var listView: TickerCurrenciesListView = {
        let lv = TickerCurrenciesListView()
        return lv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        setupNavigationBar()
        
        showLoader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }

    private func setupNavigationBar() {
        tabBar.callbackOnTouchDoneBtn = {
            [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        tabBar.searchBar.delegate = self
        view.addSubview(tabBar)
        tabBar.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: AppDelegate.isIPhone(model: .X) ? 90 : 65)
        
        view.addSubview(listView)
        listView.parentVC = self
        listView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, topConstant: AppDelegate.isIPhone(model: .X) ? 90 : 65, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

// MARK: CurrenciesListViewControllerInput
extension CurrenciesListViewController: CurrenciesListViewControllerInput {
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency]) {
        listView.datasource = CurrenciesListDataSource(items: items)
        tabBar.filter()
        hideLoader()
    }
}

// MARK: UISearchBarDelegate
extension CurrenciesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listView.filterBy(text: searchText)
    }
}

// MARK: CellDelegate
extension CurrenciesListViewController: FavCellDelegate {
    func didTouchCell(datasourceItem: Any?, isSelected: Bool) {
        output.handleTouchFavBtn(datasourceItem: datasourceItem, isSelected: isSelected)
    }
}
