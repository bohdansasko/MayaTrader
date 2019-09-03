//
//  OrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OrdersViewController: ExmoUIViewController, OrdersViewInput {
    fileprivate enum OrderAdditionalAction : Int {
        case deleteAll
        case deleteAllOnBuy
        case deleteAllOnSell
    }

    // MARK: Outlets
    var output: OrdersViewOutput!
    var isCancellingOrdersActive = false

    var pickerViewManager: DarkeningPickerViewManager!
    lazy var ordersListView = OrdersListView()
    
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
        let sc = UISegmentedControl(items: ["Open", "Cancelled", "Deals"])
        sc.tintColor = .dodgerBlue
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([
                NSAttributedString.Key.font: UIFont.getExo2Font(fontType: .regular, fontSize: 13),
            ],
            for: .normal
        )
        return sc
    }()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        output.viewIsReady()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        output.viewWillAppear()
        segmentControlView.sendActions(for: .valueChanged)
    }

    private func onSelectedDeleteAction(actionIndex: Int) {
        print("onSelectedDeleteAction: \(actionIndex)")
        isCancellingOrdersActive = true
        switch (actionIndex) {
        case OrderAdditionalAction.deleteAll.rawValue:
            ordersListView.deleteAllOrders()
            break
        case OrderAdditionalAction.deleteAllOnBuy.rawValue:
            ordersListView.deleteAllOrdersOnBuy()
            break
        case OrderAdditionalAction.deleteAllOnSell.rawValue:
            ordersListView.deleteAllOrdersOnSell()
            break
        default:
            break
        }
    }
}

// MARK: setup UI
extension OrdersViewController {
    func setupViews() {
        setupNavigationBar()
        setupSegmentControlView()
        setupBannerView()

        pickerViewManager.setCallbackOnSelectAction(callback: {
            [weak self] actionIndex in
            self?.onSelectedDeleteAction(actionIndex: actionIndex)
        })

        view.addSubview(ordersListView)
        ordersListView.anchor(segmentControlView.bottomAnchor, left: view.leftAnchor,
                              bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor,
                              topConstant: 10, leftConstant: 0,
                              bottomConstant: 0, rightConstant: 0,
                              widthConstant: 0, heightConstant: 0)
    }

    private func setupSegmentControlView() {
        view.addSubview(segmentControlView)
        segmentControlView.addTarget(self, action: #selector(onSegmentChanged(_:)), for: .valueChanged)
        segmentControlView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor,
                                  bottom: nil, right: view.rightAnchor,
                                  topConstant: 0, leftConstant: 30,
                                  bottomConstant: 0, rightConstant: 30,
                                  widthConstant: 0, heightConstant: 30)
    }

    private func setupNavigationBar() {
        titleNavBar = "Orders"
        setupRightBarButtons()
    }

    private func setupRightBarButtons() {
        buttonDeleteOrders.addTarget(self, action: #selector(OrdersViewController.onTouchButtonDelete(_:)), for: .touchUpInside)
        buttonAddOrder.addTarget(self, action: #selector(OrdersViewController.onTouchButtonAddOrder(_:)), for: .touchUpInside)

        let navButtonDeleteOrders = UIBarButtonItem(customView: buttonDeleteOrders)
        let navButtonAddOrder = UIBarButtonItem(customView: buttonAddOrder)

        navigationItem.leftBarButtonItems =  [navButtonDeleteOrders]
        navigationItem.rightBarButtonItems = [navButtonAddOrder]
    }
}

// MARK: buttons handlers
extension OrdersViewController {
    @objc func onSegmentChanged(_ sender: Any) {
        print("Orders: \(#function)")
        if isCancellingOrdersActive {
            return
        }
        let displayOrderType = OrdersType(rawValue: segmentControlView.selectedSegmentIndex)!
        ordersListView.displayOrderType = displayOrderType
        output.onDidSelectTab(displayOrderType)
    }

    @objc func onTouchButtonDelete(_ sender: Any) {
        pickerViewManager.showPickerViewWithDarkening()
    }

    @objc func onTouchButtonAddOrder(_ sender: Any) {
        output.onTouchButtonAddOrder()
    }
}


// MARK: OrdersViewInput
extension OrdersViewController {
    func updateOrders(loadedOrders: [OrdersType : Orders]) {
        print("Orders: \(#function)")
        let previousDT = ordersListView.displayOrderType
        if loadedOrders.isEmpty {
            ordersListView.openedOrders = Orders()
            ordersListView.cancelledOrders = Orders()
            ordersListView.dealsOrders = Orders()
            ordersListView.displayOrderType = previousDT
            return
        }

        for (orderType, orders) in loadedOrders {
            switch orderType {
            case .open    : ordersListView.openedOrders = orders
            case .cancelled: ordersListView.cancelledOrders = orders
            case .deals   : ordersListView.dealsOrders = orders
            default: break
            }
        }
        ordersListView.displayOrderType = previousDT
    }
    
    func orderCancelled(ids: [Int64]) {
        print("Orders: \(#function)")
        ordersListView.orderWasCancelled(ids: ids)
        isCancellingOrdersActive = false
        segmentControlView.sendActions(for: .valueChanged)
    }

    func setSubscription(_ package: CHSubscriptionPackageProtocol) {
        print("Orders: \(#function)")
        super.isAdsActive = package.isAdsPresent
        if package.isAdsPresent {
            showAdsView(completion: {
                self.ordersListView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -50).isActive = true
            })
        } else {
            print("Orders: \(#function)")
            hideAdsView(completion: {
                self.ordersListView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
            })
        }
    }
    
    func showAlert(msg: String) {
        showOkAlert(title: titleNavBar!, message: msg, onTapOkButton: nil)
    }
}
