//
//  OrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersViewController: ExmoUIViewController, OrdersViewInput {
    fileprivate enum OrderAdditionalAction : Int {
        case DeleteAll
        case DeleteAllOnBuy
        case DeleteAllOnSell
    }

    // MARK: Outlets
    var output: OrdersViewOutput!
    var currentViewController: UIViewController?
    var pickerViewManager: DarkeningPickerViewManager!
    var ordersListView: OrdersListView = {
        let lv = OrdersListView()
        return lv
    }()
    private var placeholderNoData: PlaceholderNoDataView? = nil
    
    var buttonDeleteOrders: UIButton = {
        let image = UIImage(named: "icNavbarTrash")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return button
    }()
    
    var buttonAddOrder: UIButton = {
        let image = UIImage(named: "icNavbarPlus")?.withRenderingMode(.alwaysOriginal)
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return button
    }()

    var segmentControlView: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Open", "Canceled", "Deals"])
        sc.tintColor = .dodgerBlue
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .Regular, fontSize: 13),
            ],
            for: .normal
        )
        return sc
    }()
    
    var viewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        output.viewIsReady()
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }

    
    private func onSelectedDeleteAction(actionIndex: Int) {
        print("onSelectedDeleteAction: \(actionIndex)")

        switch (actionIndex) {
        case OrderAdditionalAction.DeleteAll.rawValue:
            ordersListView.deleteAllOrders()
            break
        case OrderAdditionalAction.DeleteAllOnBuy.rawValue:
            ordersListView.deleteAllOrdersOnBuy()
            break
        case OrderAdditionalAction.DeleteAllOnSell.rawValue:
            ordersListView.deleteAllOrdersOnSell()
            break
        default:
            break
        }
    }
}

// @MARK: setup UI
extension OrdersViewController {
    func setupViews() {
        setupNavigationBar()
        setupSegmentControlView()
        
        pickerViewManager.setCallbackOnSelectAction(callback: {
            [weak self] actionIndex in
            self?.onSelectedDeleteAction(actionIndex: actionIndex)
        })
        
        view.addSubview(ordersListView)
        ordersListView.view = self
        ordersListView.anchor(segmentControlView.bottomAnchor, left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        ordersListView.showDataBySegment(displayOrderType: .Open)
    }
    
    private func setupSegmentControlView() {
        view.addSubview(segmentControlView)
        segmentControlView.addTarget(self, action: #selector(onSegmentChanged(_:)), for: .valueChanged)
        segmentControlView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 30)
    }
    
    private func setupNavigationBar() {
        setupTitleView()
        setupRightBarButtons()
    }
    
    private func setupTitleView() {
        let titleView = UILabel()
        titleView.text = "Orders"
        titleView.font = UIFont.getTitleFont()
        titleView.textColor = .white
        navigationItem.titleView = titleView
    }
    
    private func setupRightBarButtons() {
        buttonDeleteOrders.addTarget(self, action: #selector(OrdersViewController.onTouchButtonDelete(_:)), for: .touchUpInside)
        buttonAddOrder.addTarget(self, action: #selector(OrdersViewController.onTouchButtonAddOrder(_:)), for: .touchUpInside)
        
        let navButtonDeleteOrders = UIBarButtonItem(customView: buttonDeleteOrders)
        let navButtonDeleteAddOrder = UIBarButtonItem(customView: buttonAddOrder)
        let buttonSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        buttonSpacer.width = 20
        
        navigationItem.rightBarButtonItems = [buttonSpacer, navButtonDeleteOrders, navButtonDeleteAddOrder]
    }
}

// MARK: buttons handlers
extension OrdersViewController {
    @objc func onSegmentChanged(_ sender: Any) {
        ordersListView.showDataBySegment(displayOrderType: Orders.DisplayType(rawValue: segmentControlView.selectedSegmentIndex)!)
    }
    
    @objc func onTouchButtonDelete(_ sender: Any) {
        pickerViewManager.showPickerViewWithDarkening()
    }
    
    @objc func onTouchButtonAddOrder(_ sender: Any) {
        print("should show create order view")
    }
}


// MARK: OrdersViewInput
extension OrdersViewController {
    func showPlaceholderNoData() {
        if placeholderNoData != nil {
            print("placeholder no data already exists")
            return
        }
        print("show placeholder no data")
        
        placeholderNoData = PlaceholderNoDataView(frame: view.bounds)
        placeholderNoData?.setDescriptionType(descriptionType: .Orders)
        placeholderNoData?.frame = view.bounds
        view.addSubview(placeholderNoData!)
        
        placeholderNoData?.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 140)
    }
    
    func removePlaceholderNoData() {
        if placeholderNoData != nil {
            placeholderNoData?.removeFromSuperview()
            placeholderNoData = nil
        }
    }
    
    func updateOrders(loadedOrders: [Orders.DisplayType : Orders]) {
        for (orderType, orders) in loadedOrders {
            switch orderType {
            case .Open    : ordersListView.openedOrders = orders
            case .Canceled: ordersListView.canceledOrders = orders
            case .Deals   : ordersListView.dealsOrders = orders
            default: break
            }
        }
    }
}