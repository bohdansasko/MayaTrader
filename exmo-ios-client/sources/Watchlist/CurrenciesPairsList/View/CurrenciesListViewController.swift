//
//  CurrenciesListViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import LBTAComponents

protocol CurrenciesListViewControllerInput: class {
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrencyModel])
}

protocol CurrenciesListViewControllerOutput: class {
    func viewIsReady()
    func viewWillDisappear()
    func handleTouchFavBtn(datasourceItem: Any?)
}

class CurrenciesListViewController: DatasourceController, CurrenciesListViewControllerInput {
    var output: CurrenciesListViewControllerOutput!
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
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
    
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrencyModel]) {
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

// MARK: UISearchBarDelegate
extension CurrenciesListViewController: CellDelegate {
    func didTouchCell(datasourceItem: Any?) {
        output.handleTouchFavBtn(datasourceItem: datasourceItem)
    }
}
