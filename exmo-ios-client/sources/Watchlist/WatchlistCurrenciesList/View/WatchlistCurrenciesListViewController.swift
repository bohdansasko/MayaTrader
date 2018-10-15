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
        view.addSubview(tabBar)
        
        collectionView.backgroundColor = .black
        collectionView.contentInset = UIEdgeInsets(top: 65, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        
        self.datasource = CurrenciesListDatasource()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - offsetFromLeftAndRight, height: 65)
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
