//
//  CHExchangesView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

enum CHExchangeSortBy: Int, CaseIterable {
    case stock
    case pair
    case price
    case volume
    
    var apiArg: String {
        switch self {
        case .stock : return "stock_exchange"
        case .pair  : return "pair"
        case .price : return "price"
        case .volume: return "volume"
        }
    }
    
    var localized: String {
        switch self {
        case .stock : return "EXCHANGE".localized
        case .pair  : return "PAIR".localized
        case .price : return "PRICE".localized
        case .volume: return "VOLUME_24H".localized
        }
    }
    
}

enum CHSortOrder: Int, CaseIterable {
    case ascending
    case descending
    
    var apiArg: String {
        switch self {
        case .ascending : return "ascend"
        case .descending: return "descend"
        }
    }

}

final class CHExchangesView: CHBaseView {
    @IBOutlet fileprivate weak var exchangesCollectionView: UICollectionView!
    
    fileprivate(set) var searchResultsController: CHSearchCurrenciesResultsViewController!
    fileprivate(set) var searchController       : UISearchController!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
}

// MARK: - Setup methods

private extension CHExchangesView {
    
    func setupUI() {
        setupSearchController()
        setupCollectionView()
        setupSearchController()
    }
    
    func setupCollectionView() {
        exchangesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        exchangesCollectionView.register(nib: CHExchangeCell.self)
    }
    
    func setupSearchController() {
        searchResultsController = CHSearchCurrenciesResultsViewController.loadFromNib()
        
        searchController = UISearchController(searchResultsController: searchResultsController)
        
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.searchBar.placeholder = "BTC/USD"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.setInputTextFont(UIFont.getExo2Font(fontType: .medium, fontSize: 14), textColor: .white)
        searchController.searchBar.sizeToFit()
        
        let titles = CHExchangeSortBy.allCases.compactMap{ $0.localized }
        searchController.searchBar.scopeButtonTitles = titles
        
        guard
            let searchTF = searchController.searchBar.value(forKey: "searchField") as? UITextField,
            let backgroundViewTF = searchTF.subviews.first else {
                return
        }
        backgroundViewTF.backgroundColor = .white
        backgroundViewTF.layer.cornerRadius = 6
    }
    
}

// MARK: - Set methods

extension CHExchangesView {
    
    func setList(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        exchangesCollectionView.dataSource = dataSource
        exchangesCollectionView.delegate = delegate
    }
    
    func setSearchBar(delegate: UISearchBarDelegate) {
        searchController.searchBar.delegate = delegate
    }
    
    func set(searchText text: String) {
        searchController.searchBar.text = text
        searchController.isActive = true
    }
    
}
