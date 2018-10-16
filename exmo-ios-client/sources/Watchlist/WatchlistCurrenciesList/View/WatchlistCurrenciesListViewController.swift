//
//  WatchlistCurrenciesListWatchlistCurrenciesListViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import LBTAComponents

class WatchlistCurrenciesListViewController: DatasourceController, WatchlistCurrenciesListViewInput {

    var output: WatchlistCurrenciesListViewOutput!
    var tabBar: CurrenciesListTabBar!
    
    let offsetFromLeftAndRight: CGFloat = 2 * 25
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupViews()
    }

    func setupViews() {
        tabBar = CurrenciesListTabBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 95))
        tabBar.callbackOnTouchDoneBtn = {
            [weak self] in
            self?.output.closeVC()
        }
        tabBar.searchBar.delegate = self
        view.addSubview(tabBar)
        
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 65, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        
        let tapListener = UITapGestureRecognizer(target: self, action: #selector(onTapView(_:)))
        view.addGestureRecognizer(tapListener)
        
        self.datasource = CurrenciesListDatasource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - offsetFromLeftAndRight, height: 65)
    }
    
    @objc func onTapView(_ sender: Any) {
        view.endEditing(true)
    }
}

// MARK: WatchlistCurrenciesListViewInput
extension WatchlistCurrenciesListViewController {
    func setupInitialState() {
        // do nothing
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension WatchlistCurrenciesListViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width - offsetFromLeftAndRight, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: UISearchBarDelegate
extension WatchlistCurrenciesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let ds = datasource as? CurrenciesListDatasource else { return }
        ds.filterBy(text: searchText)
        collectionView.reloadData()
    }
}
