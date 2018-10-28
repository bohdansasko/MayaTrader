//
//  CurrenciesListViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

protocol CurrenciesListViewControllerInput: class {
    func onDidLoadTicker(tickerData: [String : TickerCurrencyModel])
}

protocol CurrenciesListViewControllerOutput: class {
    func viewIsReady()
}

class CurrenciesListViewController: DatasourceController, CurrenciesListViewControllerInput {
    var output: CurrenciesListViewControllerOutput!
    private var tickerContainer: [String : TickerCurrencyModel] = [:]
    
    var tabBar: CurrenciesListTabBar = {
        let tabBar = CurrenciesListTabBar()
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        prepareCollectionView()
        setupNavigationBar()
        
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.startAnimating()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 45)
    }

    private func prepareCollectionView() {
        layout?.sectionHeadersPinToVisibleBounds = true
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }

    private func setupNavigationBar() {
        tabBar = CurrenciesListTabBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 95))
        tabBar.callbackOnTouchDoneBtn = {
            [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        tabBar.searchBar.delegate = self
        view.addSubview(tabBar)
    }
    
    func onDidLoadTicker(tickerData: [String : TickerCurrencyModel]) {
        tickerContainer = tickerData
        
        let items: [WatchlistCurrencyModel] = tickerData.compactMap({(currencyPairCode: String, model: TickerCurrencyModel) in
            return WatchlistCurrencyModel(index: 1, pairName: currencyPairCode, buyPrice: model.buyPrice, timeUpdataInSecFrom1970: model.timestamp, closeBuyPrice: model.closeBuyPrice, volume: model.volume, volumeCurrency: model.volumeCurrency)
        })
        datasource = CurrenciesListDataSource(items: items)
        activityIndicatorView.stopAnimating()
    }
}

// MARK: UICollectionViewLayout
extension CurrenciesListViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: UISearchBarDelegate
extension CurrenciesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let ds = datasource as? CurrenciesListDataSource else { return }
        ds.filterBy(text: searchText)
        collectionView.reloadData()
    }
}
