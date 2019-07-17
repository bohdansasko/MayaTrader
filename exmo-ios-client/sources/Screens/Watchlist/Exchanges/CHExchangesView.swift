//
//  CHExchangesView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHExchangesView: CHBaseView {
    @IBOutlet fileprivate weak var exchangesCollectionView: UICollectionView!
    
    fileprivate(set) var searchController: UISearchController = {
        let searchResultsController = CHSearchCurrenciesResultsViewController.loadFromNib()
        let searchController = UISearchController(searchResultsController: searchResultsController)
        
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.searchBar.placeholder = "BTC/USD"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setInputTextFont(UIFont.getExo2Font(fontType: .medium, fontSize: 14), textColor: .white)
        searchController.searchBar.sizeToFit()
        searchController.searchBar.scopeButtonTitles = ["Exchange", "Pair", "Price", "Volume 24h"]
        
        return searchController
    }()
    
    override func setupUI() {
        setupCollectionView()
        setupSearchController()
    }
    
}


// MARK: - Set methods

extension CHExchangesView {
    
    func setList(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        exchangesCollectionView.dataSource = dataSource
        exchangesCollectionView.delegate = delegate
    }
    
    func set(searchText text: String) {
        searchController.searchBar.text = text
        searchController.isActive = true
    }
    
}

// MARK: - Setup methods

private extension CHExchangesView {
    
    func setupCollectionView() {
        exchangesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        exchangesCollectionView.register(nib: CHExchangeCell.self)
    }
    
    func setupSearchController() {
        guard
            let searchTF = searchController.searchBar.value(forKey: "searchField") as? UITextField,
            let backgroundViewTF = searchTF.subviews.first else {
                return
        }
        backgroundViewTF.backgroundColor = .white
        backgroundViewTF.layer.cornerRadius = 6
    }
    
}
