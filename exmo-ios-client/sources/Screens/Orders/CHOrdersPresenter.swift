//
//  CHOrdersPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 8/18/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit
import RxSwift

protocol CHOrdersPresenterDelegate: class {
    func ordersPresenter(_ presenter: CHOrdersPresenter, didLoadOrders orders: [OrderModel])
    func ordersPresenter(_ presenter: CHOrdersPresenter, onError error: Error)
}

final class CHOrdersPresenter: NSObject {
    
    // MARK: - Private properties
    
    fileprivate var tableView : UITableView
    fileprivate var exmoAPI   : CHExmoAPI
    fileprivate var dataSource: CHOrdersDataSource

    fileprivate(set) var isAllOrdersDownloaded = false
    fileprivate      var cachedCellsHeights: [IndexPath: CGFloat] = [:]
    fileprivate(set) var selectedOrdersTab : OrdersType = .open
    fileprivate      var loadingRequest    : Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }
    
    // MARK: - Public properties
    
    var isDeleteActionsAllow: Bool {
        return selectedOrdersTab == .open ? true : false
    }
    
    var kLimitItemsForLoading: Int { return 20 }
    
    weak var delegate: CHOrdersPresenterDelegate?
    
    // MARK: - View life cycle
    
    init(tableView: UITableView, exmoAPI: CHExmoAPI, dataSource: CHOrdersDataSource) {
        self.tableView  = tableView
        self.exmoAPI    = exmoAPI
        self.dataSource = dataSource
        
        super.init()

        setupTableView()
    }
    
    deinit {
        loadingRequest = nil
    }

}

// MARK: - Public methods for manage order list

extension CHOrdersPresenter {

    func resetOrders(for ordersTab: OrdersType) {
        isAllOrdersDownloaded = false
        dataSource.set([])
        tableView.reloadData()
        fetchOrders(for: ordersTab, offset: 0)
    }

}

// MARK: - Private methods for manage order list

private extension CHOrdersPresenter {
    
    func fetchOrders(for ordersTab: OrdersType, offset: Int) {
        print("\(#function), \(ordersTab), offset = \(offset)")
        self.selectedOrdersTab = ordersTab

        switch ordersTab {
        case .open:
            let request = exmoAPI.rx.getOpenOrders()
            loadingRequest = request.subscribe(
                onSuccess: { [weak self] orders in
                    self?.handleFetchedOrders(orders, offset: offset)
                },
                onError: self.handleError
            )
        case .cancelled:
            let request = exmoAPI.rx.getCancelledOrders(limit: kLimitItemsForLoading, offset: offset)
            loadingRequest = request.subscribe(
                onSuccess: { [weak self] orders in
                    self?.handleFetchedOrders(orders, offset: offset)
                },
                onError: self.handleError
            )
        case .deals:
            let request = exmoAPI.rx.getDealsOrders(limit: kLimitItemsForLoading, offset: offset)
            loadingRequest = request.subscribe(
                onSuccess: { [weak self] orders in
                    self?.handleFetchedOrders(orders, offset: offset)
                },
                onError: self.handleError
            )
        }
    }

    func fetchOrdersIfNeeded(indexPath: IndexPath) {
        let lastItemIdx = indexPath.section + 3
        if lastItemIdx > dataSource.items.count {
            fetchOrders(for: self.selectedOrdersTab, offset: dataSource.items.count)
        }
    }

    func handleFetchedOrders(_ orders: [OrderModel], offset: Int) {
        self.delegate?.ordersPresenter(self, didLoadOrders: orders)
        
        self.isAllOrdersDownloaded = orders.isEmpty
        if self.isAllOrdersDownloaded { return }
        
        self.dataSource.append(orders)
        
        let lastIndex = offset + orders.count
        let sections = IndexSet(integersIn: offset..<lastIndex)
        
        self.tableView.beginUpdates()
        self.tableView.insertSections(sections, with: .none)
        self.tableView.endUpdates()
    }
    
    func handleError(error: Error) {
        self.delegate?.ordersPresenter(self, onError: error)
    }
    
}

// MARK: - Setup methods

private extension CHOrdersPresenter {

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(class: OrderViewCell.self)
    }
    
}

// MARK: - UITableViewDelegate

extension CHOrdersPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: tableView.frame)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return view
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let order = dataSource.item(for: indexPath)
        let orderCell = cell as! OrderViewCell
        orderCell.order = order
        
        cachedCellsHeights[indexPath] = cell.frame.height
        
        fetchOrdersIfNeeded(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cachedCellsHeights[indexPath] ?? 85
    }
    
}
