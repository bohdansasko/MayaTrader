//
//  CHExchangesView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHExchangesView: UIView {
    @IBOutlet fileprivate      weak var exchangesCollectionView: UICollectionView!
                   fileprivate(set) var searchController: UISearchController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}


// MARK: - Set methods

extension CHExchangesView {
    
    func set(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        exchangesCollectionView.dataSource = dataSource
        exchangesCollectionView.delegate = delegate
    }
    
    func set(searchResultsUpdater: UISearchResultsUpdating) {
        searchController.searchResultsUpdater = searchResultsUpdater
    }
    
}

// MARK: - Setup methods

private extension CHExchangesView {
    
    func setupUI() {
        let searchResultsController = CHSearchCurrenciesResultsViewController.loadFromNib()
        searchController = UISearchController(searchResultsController: searchResultsController)
        
        setupCollectionView()
        setupSearchController()
    }
    
    func setupCollectionView() {
        exchangesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        exchangesCollectionView.register(nib: CHExchangeCell.self)
    }
    
    func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.searchBar.placeholder = "BTC/USD"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setInputTextFont(UIFont.getExo2Font(fontType: .medium, fontSize: 14), textColor: .white)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Exchange", "Pair", "Price", "Volume 24h"]
        searchController.searchBar.showsScopeBar = true
        
        guard
            let searchTF = searchController.searchBar.value(forKey: "searchField") as? UITextField,
            let backgroundViewTF = searchTF.subviews.first else {
                return
        }
        backgroundViewTF.backgroundColor = .white
        backgroundViewTF.layer.cornerRadius = 6
    }
    
}
