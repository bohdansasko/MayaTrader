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
}

final class CHOrdersPresenter: NSObject {
    
    // MARK: - Private properties
    
    fileprivate var tableView : UITableView
    fileprivate var exmoAPI   : CHExmoAPI
    fileprivate var dataSource: CHOrdersDataSource
    
    fileprivate(set) var selectedOrdersTab: OrdersType = .open
    fileprivate var loadingRequest   : Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }
    
    // MARK: - Public properties
    
    var isDeleteActionsAllow: Bool {
        return selectedOrdersTab == .open ? true : false
    }
    
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
    
    func fetchOrders(for ordersTab: OrdersType) {
        self.selectedOrdersTab = ordersTab
        
        switch ordersTab {
        case .open:
            let request = exmoAPI.rx.getOpenOrders()
            loadingRequest = request.subscribe(onSuccess: { [weak self] orders in
                guard let `self` = self else { return }
                self.dataSource.set(orders)
                self.tableView.reloadData()
                self.delegate?.ordersPresenter(self, didLoadOrders: orders)
            }, onError: { err in
                print(err.localizedDescription)
            })
        case .cancelled:
            let request = exmoAPI.rx.getCancelledOrders(limit: 20, offset: 0)
            loadingRequest = request.subscribe(onSuccess: { [weak self] orders in
                guard let `self` = self else { return }
                self.dataSource.set(orders)
                self.tableView.reloadData()
                self.delegate?.ordersPresenter(self, didLoadOrders: orders)
            }, onError: { err in
                print(err.localizedDescription)
            })
        case .deals:
            let request = exmoAPI.rx.getDealsOrders(limit: 20, offset: 0)
            loadingRequest = request.subscribe(onSuccess: { [weak self] orders in
                guard let `self` = self else { return }
                self.dataSource.set(orders)
                self.tableView.reloadData()
                self.delegate?.ordersPresenter(self, didLoadOrders: orders)
            }, onError: { err in
                print(err.localizedDescription)
            })
        }
    
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !isDeleteActionsAllow {
            return UISwipeActionsConfiguration(actions: [])
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "", handler: {
            [unowned self] action, view, completionHandler  in
//            self?.cancelOrderAt(indexPath: indexPath)
            print("called delete action for row = \(indexPath.section)")
            completionHandler(true)
        })
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.3764705882, alpha: 1)
        deleteAction.image = #imageLiteral(resource: "icNavbarTrash")

        let configurator = UISwipeActionsConfiguration(actions: [deleteAction])
        return configurator
    }
    
}
