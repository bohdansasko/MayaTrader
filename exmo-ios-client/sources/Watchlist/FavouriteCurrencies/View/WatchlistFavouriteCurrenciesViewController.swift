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

class WatchlistFavouriteCurrenciesViewController: DatasourceController, WatchlistFavouriteCurrenciesViewInput, CellDelegate {

    var output: WatchlistFavouriteCurrenciesViewOutput!
    let spaceFromLeftOrRight: CGFloat = 10
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        setupInitialState()
    }
    
    // MARK: WatchlistFavouriteCurrenciesViewInput
    func setupInitialState() {
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 25, left: spaceFromLeftOrRight, bottom: 0, right: spaceFromLeftOrRight)
        
        setupNavigationBar()
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
    
    //
    // @MARK: setup collection
    //
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCols: CGFloat = 10
        return CGSize(width: (view.frame.width - spaceBetweenCols - 2 * spaceFromLeftOrRight)/2, height: 115)
    }
    
    func didTouchCell(datasourceItem: Any?) {
        guard let currencyModel = datasourceItem as? WatchlistCurrencyModel else { return }
        print("Touched \(currencyModel.pairName)")
        output.handleTouchCell(watchlistCurrencyModel: currencyModel)
    }
    
    func presentFavouriteCurrencies(items: [WatchlistCurrencyModel]) {
        datasource = WatchlistFavouriteDataSource(items: items)
    }
}

//
// @MARK: 
//
extension WatchlistFavouriteCurrenciesViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//
// @MARK: navigation bar
//
extension WatchlistFavouriteCurrenciesViewController {
    func setupNavigationBar() {
        setupTitleNavigationBar(text: "Watchlist")
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
