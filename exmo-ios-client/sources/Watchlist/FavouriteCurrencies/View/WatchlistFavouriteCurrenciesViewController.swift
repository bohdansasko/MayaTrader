//
//  WatchlistFavouriteCurrenciesViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import LBTAComponents

protocol CellDelegate: class {
    func didTouchCell(datasourceItem: Any?)
}

extension DatasourceController {
    func setupTitleNavigationBar(text: String) {
        let titleView = UILabel()
        titleView.text = text
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
}

// @MARK: WatchlistFavouriteCurrenciesViewController
class WatchlistFavouriteCurrenciesViewController: ExmoUIViewController, WatchlistFavouriteCurrenciesViewInput, CellDelegate {
    var output: WatchlistFavouriteCurrenciesViewOutput!

    var listView: WatchlistListView = WatchlistListView()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialState()
        output.viewIsReady()
    }
    
    func setupInitialState() {
        setupNavigationBar()

        view.addSubview(listView)
        listView.frame = self.view.bounds
        listView.anchor(view.layoutMarginsGuide.topAnchor, left: view.layoutMarginsGuide.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        listView.presenter = output
        listView.datasource = WatchlistCardsDataSource(items: [])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarColor()
        output.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }

    // @MARK: setup collection
    func didTouchCell(datasourceItem: Any?) {
        guard let currencyModel = datasourceItem as? WatchlistCurrency else { return }
        print("Touched \(currencyModel.tickerPair.code)")
        output.handleTouchCell(watchlistCurrencyModel: currencyModel)
    }
    
    func presentFavouriteCurrencies(items: [WatchlistCurrency]) {
        print("update currencies")
        guard let ds = listView.datasource as? WatchlistCardsDataSource else {
            return
        }
        hideLoader()

        let shouldReloadData = ds.items.count != items.count
        ds.items = items

        if shouldReloadData {
            listView.collectionView.reloadData()
        } else {
            listView.collectionView.visibleCells.forEach({
                collectionCell in
                guard let dsCell = collectionCell as? ExmoCollectionCell,
                      var dsItem = dsCell.datasourceItem as? WatchlistCurrency,
                      let item = ds.item(IndexPath(item: dsItem.index, section: 0)) as? WatchlistCurrency else {
                    return
                }
                dsItem.tickerPair = item.tickerPair
            })
        }
    }


}

// @MARK: navigation bar
extension WatchlistFavouriteCurrenciesViewController {
    func setupNavigationBar() {
        titleNavBar = "Watchlist"
        setupLeftNavigationBarItems()
    }
    
    func setupNavigationBarColor() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupLeftNavigationBarItems() {
        let addCurrencyPairsBtn = UIButton(type: .system)
        addCurrencyPairsBtn.setImage(UIImage(imageLiteralResourceName: "icNavbarPlus").withRenderingMode(.alwaysOriginal), for: .normal)
        addCurrencyPairsBtn.addTarget(self, action: #selector(onTouchAddCurrencyPairsBtn(_:)), for: .touchUpInside)
        let addCurrencyBarItem = UIBarButtonItem(customView: addCurrencyPairsBtn)
        navigationItem.rightBarButtonItem = addCurrencyBarItem
    }
    
    @objc func onTouchAddCurrencyPairsBtn(_ sender: Any) {
        output.showCurrenciesListVC()
    }

}

extension WatchlistFavouriteCurrenciesViewController: CurrenciesListViewControllerInput {
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency]) {

    }
}