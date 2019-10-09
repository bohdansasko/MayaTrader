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
        setupNotificationsSubscription()
        
        contentView.select(tab: presenter.selectedOrdersTab)
        presenter.resetOrders(for: presenter.selectedOrdersTab)
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
                                      exmoAPI   : exmoAPI,
                                      dataSource: ordersDataSource)
        presenter.delegate = self
    }
    
    func setupNotificationsSubscription() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationUserAuthorization(_:)),
                                               name: AuthorizationNotification.userFailSignIn)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationUserAuthorization(_:)),
                                               name: AuthorizationNotification.userSignIn)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNotificationUserAuthorization(_:)),
                                               name: AuthorizationNotification.userSignOut)
    }
    
}

// MARK: - User interaction

private extension CHOrdersViewController {
    
    @objc func actSelectTab(_ sender: Any) {
        presenter.resetOrders(for: contentView.selectedOrdersTab)
    }
    
}

// MARK: - Notifications

private extension CHOrdersViewController {
    
    @objc func handleNotificationUserAuthorization(_ notification: Notification) {
        presenter.resetOrders(for: contentView.selectedOrdersTab)
    }
    
}

// MARK: - CHOrdersPresenterDelegate

extension CHOrdersViewController: CHOrdersPresenterDelegate {
    
    func ordersPresenter(_ presenter: CHOrdersPresenter, didLoadOrders orders: [OrderModel]) {
        contentView.isTutorialStubVisible = orders.isEmpty
    }
    
    func ordersPresenter(_ presenter: CHOrdersPresenter, onError error: Error) {
        handleError(error)
    }
    
}

