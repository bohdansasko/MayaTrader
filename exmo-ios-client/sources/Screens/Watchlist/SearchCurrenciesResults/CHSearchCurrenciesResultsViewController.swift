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

        // Do any additional setup after loading the view.
    }

}

// MARK: - UISearchResultsUpdating

extension CHSearchCurrenciesResultsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text ?? "Nothing")
    }
    
}

