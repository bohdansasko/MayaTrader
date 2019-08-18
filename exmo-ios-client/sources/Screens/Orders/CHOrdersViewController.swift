//
//  CHOrdersViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHOrdersViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHOrdersView
    
    fileprivate var presenter: CHOrdersPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        contentView.set(target: self, actionOnSelectTab: #selector(actSelectTab(_:)))
        setupPresenter()
        
        contentView.select(tab: presenter.selectedOrdersTab)
    }
    
}

// MARK: - Setup methods

private extension CHOrdersViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "TAB_ORDERS".localized
    }
    
    func setupPresenter() {
        let ordersDataSource = CHOrdersDataSource(items: [])
        presenter = CHOrdersPresenter(tableView : contentView.ordersListView,
                                      exmoAPI   : CHExmoAPI.shared,
                                      dataSource: ordersDataSource)
        presenter.delegate = self
    }
}

// MARK: - User interaction

private extension CHOrdersViewController {
    
    @objc func actSelectTab(_ sender: Any) {
        presenter.fetchOrders(for: contentView.selectedOrdersTab)
    }
    
}

// MARK: - CHOrdersPresenterDelegate

extension CHOrdersViewController: CHOrdersPresenterDelegate {
    
    func ordersPresenter(_ presenter: CHOrdersPresenter, didLoadOrders orders: [OrderModel]) {
        contentView.isTutorialStubVisible = orders.isEmpty
    }
    
}
