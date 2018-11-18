//
//  SearchViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    enum SearchType {
        case None
        case Currencies
        case Sounds
    }
    
    var output: SearchViewOutput!
    
    var tabBar = CurrenciesListTabBar()
    var listView = SearchDatasourceListView()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        return aiv
    }()
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        output.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }
    
    deinit {
        print("deinit \(String(describing: self))")
    }
}

extension SearchViewController {
    func setupViews() {
        view.backgroundColor = .black
        
        setupNavigationBar()
        setupCurrenciesList()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
        activityIndicatorView.startAnimating()
    }
    
    private func setupNavigationBar() {
        view.addSubview(tabBar)
        tabBar.callbackOnTouchDoneBtn = {
            [weak self] in
            self?.output.closeVC()
        }
        tabBar.searchBar.delegate = self
        tabBar.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 44)
    }
    
    private func setupCurrenciesList() {
        view.addSubview(listView)
        listView.output = output
        listView.anchor(tabBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        listView.filterBy(text: searchText)
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: SearchViewInput {
    func updatePairsList(_ pairs: [SearchCurrencyPairModel]) {
        activityIndicatorView.stopAnimating()
        listView.originalPairs = pairs
        tabBar.filter()
    }
}

