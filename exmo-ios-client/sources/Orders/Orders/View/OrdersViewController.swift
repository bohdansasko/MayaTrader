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
        case DeleteAll
        case DeleteAllOnBuy
        case DeleteAllOnSell
    }

    // MARK: Outlets
    var output: OrdersViewOutput!
    var currentViewController: UIViewController?
    var bannerView: GADBannerView!
    
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
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewIsReady()

        segmentControlView.sendActions(for: .valueChanged)
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
        setupBannerView()
        
        pickerViewManager.setCallbackOnSelectAction(callback: {
            [weak self] actionIndex in
            self?.onSelectedDeleteAction(actionIndex: actionIndex)
        })
        
        view.addSubview(ordersListView)
        ordersListView.anchor(segmentControlView.bottomAnchor, left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    private func setupSegmentControlView() {
        view.addSubview(segmentControlView)
        segmentControlView.addTarget(self, action: #selector(onSegmentChanged(_:)), for: .valueChanged)
        segmentControlView.anchor(view.layoutMarginsGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 0, rightConstant: 30, widthConstant: 0, heightConstant: 30)
    }
    
    private func setupNavigationBar() {
        titleNavBar = "Orders"
        setupRightBarButtons()
    }
    
    private func setupRightBarButtons() {
        buttonDeleteOrders.addTarget(self, action: #selector(OrdersViewController.onTouchButtonDelete(_:)), for: .touchUpInside)
        buttonAddOrder.addTarget(self, action: #selector(OrdersViewController.onTouchButtonAddOrder(_:)), for: .touchUpInside)
        
        let navButtonDeleteOrders = UIBarButtonItem(customView: buttonDeleteOrders)
        let navButtonDeleteAddOrder = UIBarButtonItem(customView: buttonAddOrder)

        let rightShift = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        rightShift.width = 20

        let spaceBetweenButtons = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceBetweenButtons.width = 12

        navigationItem.rightBarButtonItems = [rightShift,
                                              navButtonDeleteOrders,
                                              spaceBetweenButtons,
                                              navButtonDeleteAddOrder]
    }
    
    func setupBannerView() {
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
    }
    
    func addBannerToView(_ bannerView: GADBannerView) {
        view.addSubview(bannerView)
        bannerView.anchor(nil, left: view.layoutMarginsGuide.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.layoutMarginsGuide.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

// MARK: buttons handlers
extension OrdersViewController {
    @objc func onSegmentChanged(_ sender: Any) {
        let displayOrderType = Orders.DisplayType(rawValue: segmentControlView.selectedSegmentIndex)!
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
    func updateOrders(loadedOrders: [Orders.DisplayType : Orders]) {
        let previousDT = ordersListView.displayOrderType
        if loadedOrders.isEmpty {
            ordersListView.openedOrders = Orders()
            ordersListView.canceledOrders = Orders()
            ordersListView.dealsOrders = Orders()
            ordersListView.displayOrderType = previousDT
            return
        }

        for (orderType, orders) in loadedOrders {
            switch orderType {
            case .Open    : ordersListView.openedOrders = orders
            case .Canceled: ordersListView.canceledOrders = orders
            case .Deals   : ordersListView.dealsOrders = orders
            default: break
            }
        }
        ordersListView.displayOrderType = previousDT
    }
    
    func orderCanceled(id: Int64) {
        ordersListView.orderWasCanceled(id: id)
    }
}

// @MARK: GADBannerViewDelegate
extension OrdersViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Orders: adViewDidReceiveAd")
        if let _ = bannerView.superview {
            bannerView.alpha = 0
            UIView.animate(withDuration: 1) {
                bannerView.alpha = 1
                self.ordersListView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -50).isActive = true
            }
        } else {
            addBannerToView(bannerView)
        }
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
        UIView.animate(withDuration: 1) {
            bannerView.alpha = 0
            self.ordersListView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        }
    }
}
