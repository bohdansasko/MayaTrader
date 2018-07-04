//
//  SearchCurrencyPairSearchCurrencyPairViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchCurrencyPairViewController: UIViewController, SearchCurrencyPairViewInput {

    var output: SearchCurrencyPairViewOutput!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var layoutConstraintHeaderHeight: NSLayoutConstraint!
    
    private var displayManager: SearchCurrencyPairDisplayManager!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        setupInitialState()
    }


    // MARK: SearchCurrencyPairViewInput
    func setupInitialState() {
        if AppDelegate.shared.isIPhone(model: .X) {
            self.layoutConstraintHeaderHeight.constant = 95
        }
        
        self.displayManager = SearchCurrencyPairDisplayManager(dataProvider: [
            SearchCurrencyPairModel(id: 1, name: "BTC/USD", price: 7809.976),
            SearchCurrencyPairModel(id: 2, name: "BTC/EUR", price: 6009.65),
            SearchCurrencyPairModel(id: 3, name: "BTC/UAH", price: 51090.0),
            SearchCurrencyPairModel(id: 4, name: "EUR/USD", price: 109.976),
            SearchCurrencyPairModel(id: 5, name: "UAH/USD", price: 709.976),
            SearchCurrencyPairModel(id: 6, name: "UAH/BTC", price: 809.976),
            SearchCurrencyPairModel(id: 7, name: "EUR/BTC", price: 9871.976)
        ])
        self.displayManager.output = output
        self.displayManager.setSearchBar(searchBar: searchBar)
        self.displayManager.setTableView(tableView: tableView)
    }
    
    @IBAction func closeView() {
        self.output.handleCloseView()
    }
}
