//
//  CHExchangesViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/14/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

struct CHExchangeModel {
    var icon: UIImage
    var name: String
}

final class CHExchangesViewController: CHViewController, CHViewControllerProtocol {
    typealias ContentView = CHExchangesView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPresenterAndDataSource()
        setupNavigationBar()
        definesPresentationContext = true
    }
    
}

// MARK: - Setup methods

private extension CHExchangesViewController {
    
    func setupNavigationBar() {
        navigationItem.titleView = nil
        navigationItem.title = "SCREEN_CURRENCIES_GROUP_TITLE".localized
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = contentView.searchController
    }
    
    func setupPresenterAndDataSource() {
        let networkAPI = TickerNetworkWorker()
        let dataSource = CHExchangeDataSource()
        let presenter = CHExchangePresenter(api: networkAPI, dataSource: dataSource)
        contentView.set(dataSource: dataSource, delegate: presenter)
    }
    
}

// MARK: - Actions

private extension CHExchangesViewController {
    
    @IBAction func actClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
