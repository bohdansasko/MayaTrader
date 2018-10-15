//
//  WatchlistFavouriteCurrenciesViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import LBTAComponents

class WatchlistFavouriteCurrenciesViewController: DatasourceController, WatchlistFavouriteCurrenciesViewInput {

    var output: WatchlistFavouriteCurrenciesViewOutput!
    let spaceFromLeftOrRight: CGFloat = 20
    
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
        setupNavigationBarColor()
    }
    
    //
    // @MARK: setup collection
    //
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCols: CGFloat = 15
        return CGSize(width: (view.frame.width - spaceBetweenCols - 2 * spaceFromLeftOrRight)/2, height: 80)
    }
}

//
// @MARK: 
//
extension WatchlistFavouriteCurrenciesViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
//
// @MARK: navigation bar
//
extension WatchlistFavouriteCurrenciesViewController {
    func setupNavigationBar() {
        setupTitleNavigationBar()
        setupLeftNavigationBarItems()
    }
    
    func setupNavigationBarColor() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupTitleNavigationBar() {
        let titleView = UILabel()
        titleView.text = "Watchlist"
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
    
    private func setupLeftNavigationBarItems() {
        let addCurrencyPairsBtn = UIButton(type: .system)
        addCurrencyPairsBtn.setImage(UIImage(imageLiteralResourceName: "icNavbarPlus").withRenderingMode(.alwaysOriginal), for: .normal)
        let addCurrencyBarItem = UIBarButtonItem(customView: addCurrencyPairsBtn)
        navigationItem.rightBarButtonItem = addCurrencyBarItem
    }
}
