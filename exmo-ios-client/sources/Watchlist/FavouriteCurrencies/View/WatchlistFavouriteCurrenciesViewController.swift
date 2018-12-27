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
    fileprivate var longPressGesture: UILongPressGestureRecognizer!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        setupInitialState()

        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
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

    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        guard let collectionView = collectionView else { return }

        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    // @MARK: setup collection
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spaceBetweenCols: CGFloat = 10
        return CGSize(width: (view.frame.width - spaceBetweenCols - 2 * spaceFromLeftOrRight)/2, height: 115)
    }
    
    func didTouchCell(datasourceItem: Any?) {
        guard let currencyModel = datasourceItem as? WatchlistCurrency else { return }
        print("Touched \(currencyModel.tickerPair.code)")
        output.handleTouchCell(watchlistCurrencyModel: currencyModel)
    }
    
    func presentFavouriteCurrencies(items: [WatchlistCurrency]) {
        print("collectionView.isDragging = \(collectionView.isDragging)")
        datasource = WatchlistFavouriteDataSource(items: items)
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let ds = datasource as? WatchlistFavouriteDataSource else {
            return
        }
        print("s index = \(ds.items[sourceIndexPath.item].index), dindex = \(ds.items[destinationIndexPath.item].index)")
        guard let temp = ds.item(destinationIndexPath) as? WatchlistCurrency else { return }
        ds.items[destinationIndexPath.item] = ds.items[sourceIndexPath.item]
        ds.items[sourceIndexPath.item] = temp
        print("s index = \(ds.items[sourceIndexPath.item].index), dindex = \(ds.items[destinationIndexPath.item].index)")
    }
}

extension WatchlistFavouriteCurrenciesViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

// @MARK: navigation bar
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