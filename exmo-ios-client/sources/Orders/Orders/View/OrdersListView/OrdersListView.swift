//
//  OrdersListView.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 3/20/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation
import UIKit

class OrdersListView: UIView {
    var tableView: UITableView = {
        let tv = UITableView()
        tv.allowsSelection = false
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.tableFooterView = UIView()
        tv.delaysContentTouches = false
        return tv
    }()
    
    private var placeholderNoData: PlaceholderNoDataView = {
        let view = PlaceholderNoDataView()
        view.isHidden = true
        return view
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.hidesWhenStopped = true
        aiv.color = .white
        return aiv
    }()

    var tutorialImg: TutorialImage = {
        let img = TutorialImage()
        img.imageName = "imgTutorialOrder"
        img.offsetByY = -60
        return img
    }()

    weak var presenter: OrdersViewOutput!
    var dataProvider: Orders!
    var tableViewCells: [Int64 : IndexPath] = [:]
    var displayOrderType: Orders.DisplayType = .None {
        didSet {
            showDataBySegment(displayOrderType: displayOrderType)
        }
    }
    let kCellId = "OrderCell"
    var shouldUseActions: Bool = false
    
    var openedOrders: Orders? {
        didSet { displayOrderType = .Open }
    }
    var canceledOrders: Orders? {
        didSet { displayOrderType = .Canceled }
    }
    var dealsOrders: Orders? {
        didSet { displayOrderType = .Deals }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func isDataExists() -> Bool {
        return dataProvider.isDataExists()
    }

    func showDataBySegment(displayOrderType: Orders.DisplayType) {
        guard let data = getDataBySegmentIndex(displayOrderType: displayOrderType) else {
            dataProvider = Orders()
            updateTableUI()
            return
        }
        dataProvider = data
        shouldUseActions = displayOrderType == .Open
        updateTableUI()
    }

    // MARK: private methods
    private func getDataBySegmentIndex(displayOrderType: Orders.DisplayType) -> Orders? {
        switch displayOrderType {
            case .Open: return openedOrders
            case .Canceled: return canceledOrders
            default: return dealsOrders
        }
    }
}

// MARK: setup UI
extension OrdersListView {
    func updateTableUI() {
        checkOnRequirePlaceHolder()
        tableView.reloadData()
    }
    
    func setupViews() {
        setupTutorialImg()
        setupTableView()
        setupPlaceholderNoData()
        
        addSubview(activityIndicatorView)
        activityIndicatorView.anchorCenterSuperview()
    }

    func setupTutorialImg() {
        self.addSubview(tutorialImg)
        tutorialImg.anchorCenterSuperview()
    }

    private func setupPlaceholderNoData() {
        self.addSubview(placeholderNoData)
        let topOffset: CGFloat = AppDelegate.isIPhone(model: .Five) ? -5 : 50
        placeholderNoData.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: topOffset, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderViewCell.self, forCellReuseIdentifier: kCellId)
    }
    
    func checkOnRequirePlaceHolder() {
        if (dataProvider.isDataExists()) {
            activityIndicatorView.stopAnimating()
            removePlaceholderNoData()
        } else {
            removePlaceholderNoData()
            activityIndicatorView.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                [weak self] in
                guard let isDataExists = self?.dataProvider.isDataExists() else { return }
                if (!isDataExists) {
                    self?.activityIndicatorView.stopAnimating()
                    self?.showPlaceholderNoData()
                }
            })
        }
    }
}

// @MARK: help operations for orders
extension OrdersListView {
    func appendOpenOrder(orderModel: OrderModel) {
        if (displayOrderType == .Open) {
            openedOrders = AppDelegate.session.getOpenOrders()
            dataProvider.append(orderModel: orderModel)
            tableView.insertSections(IndexSet(integer: 0), with: .automatic)
            checkOnRequirePlaceHolder()
        }
    }

    func cancelOrderAt(indexPath: IndexPath) {
        self.activityIndicatorView.startAnimating()
        let id = dataProvider.getOrderBy(index: indexPath.section).id
        presenter.cancelOrder(ids: [id])
    }

    func deleteAllOrdersOnBuy() {
        print("delete all orders on buy")
        deleteAllOrdersOn(deleteOrderType: .Buy)
    }

    func deleteAllOrdersOnSell() {
        print("delete all orders on sell")
        deleteAllOrdersOn(deleteOrderType: .Sell)
    }

    private func deleteAllOrdersOn(deleteOrderType: OrderActionType) {
        guard let openedOrders = openedOrders else {
            print("deleteOrders: openedOrders == nil")
            return
        }

        var ids: [Int64] = []
        let _ = openedOrders.getOrders().filter({ $0.orderType == deleteOrderType }).forEach({ ids.append($0.id) })
        presenter.cancelOrder(ids: ids)
    }
    
    func deleteAllOrders() {
        print("delete all orders")
        
        guard let openedOrders = openedOrders else {
            print("deleteAllOrders: openedOrders == nil")
            return
        }
        var ids: [Int64] = []
        openedOrders.getOrders().forEach({ ids.append($0.id) })
        presenter.cancelOrder(ids: ids)
    }
    
    func orderWasCanceled(ids: [Int64]) {
        for id in ids {
            guard let indexPath = tableViewCells[id] else {
                print("orderWasCanceled: can't find cell for remove")
                return
            }
            dataProvider.removeItem(byIndex: indexPath.section)
            tableViewCells.removeValue(forKey: id)
            tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
        checkOnRequirePlaceHolder()
    }
}

// @MARK: placeholder
extension OrdersListView {
    func showPlaceholderNoData() {
        placeholderNoData.isHidden = displayOrderType == .Open
        switch displayOrderType {
        case .Open:
            tutorialImg.show()
            placeholderNoData.text = nil
        case .Canceled:
            placeholderNoData.text = "You haven't canceled orders right now"
        case .Deals:
            placeholderNoData.text = "You haven't deals orders right now"
        default: break
        }
    }
    
    func removePlaceholderNoData() {
        placeholderNoData.isHidden = true
        tutorialImg.hide()
    }
}
