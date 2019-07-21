//
//  SearchCurrenciesResultsViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHSearchCurrenciesResultsViewController: CHViewController, CHViewControllerProtocol {
    typealias ContentView = CHSearchCurrenciesResultsView
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UISearchResultsUpdating

extension CHSearchCurrenciesResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? "<No string>"
        print(#function, searchText)
    }
    
}

