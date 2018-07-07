//
//  SearchViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, SearchViewInput {
    enum SearchType {
        case None
        case Currencies
        case Sounds
    }
    
    var output: SearchViewOutput!
    var displayManager: SearchDisplayManager!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var layoutConstraintHeaderHeight: NSLayoutConstraint!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        setupInitialState()
    }


    // MARK: SearchViewInput
    func setupInitialState() {
        if AppDelegate.shared.isIPhone(model: .X) {
            self.layoutConstraintHeaderHeight.constant = 95
        }
        
        self.displayManager.setSearchBar(searchBar: searchBar)
        self.displayManager.setTableView(tableView: self.tableView)
    }
    
    @IBAction func closeView() {
        self.output.handleCloseView()
    }
    
    //
    //@ this method called before viewDidLoad
    //
    func setSearchData(_ searchType: SearchViewController.SearchType, _ data: [SearchModel]) {
        self.displayManager.setData(dataProvider: data, searchType: searchType)
    }
}
