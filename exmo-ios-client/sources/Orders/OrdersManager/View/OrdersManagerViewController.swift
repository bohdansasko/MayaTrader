//
//  OrdersManagerOrdersManagerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersManagerViewController: ExmoUIViewController, OrdersManagerViewInput {
    // MARK: Outlets
    var output: OrdersManagerViewOutput!
    var currentViewController: UIViewController?
    var pickerViewManager: DarkeningPickerViewManager!
    var displayManager: OrdersDisplayManager!
    private var placeholderNoData: PlaceholderNoDataView? = nil
    
    // @IBOutlets
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.output.viewIsReady()
        self.setupInitialState()
        self.subscribeOnEvents()
    }
    
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }

    // MARK: public methods
    func setupInitialState() {
        let segmentControlTextFont = UIFont.getExo2Font(fontType: .Regular, fontSize: 13)
        self.segmentController.setTitleTextAttributes(
            [ NSAttributedStringKey.font: segmentControlTextFont ],
            for: .normal
        )
        
        self.displayManager.setTableView(tableView: self.tableView)
        self.displayManager.showDataBySegment(displayOrderType: .Opened)
        
//        if AppDelegate.session.isOpenedOrdersLoaded() {
//            // do nothing
//        }
//        if AppDelegate.session.isCanceledOrdersLoaded() {
//            self.onCanceledOrdersLoaded()
//        }
//        if AppDelegate.session.isDealsOrdersLoaded() {
//            self.onDealsOrdersLoaded()
//        }
    }
    
    // MARK: OrdersManagerViewInput
    func showPlaceholderNoData() {
        if placeholderNoData != nil {
            print("placeholder no data already exists")
            return
        }
        print("show placeholder no data")
        
        self.placeholderNoData = PlaceholderNoDataView(frame: self.view.bounds)
        self.placeholderNoData?.setDescriptionType(descriptionType: .Orders)
        self.placeholderNoData?.frame = self.view.bounds
        self.view.addSubview(self.placeholderNoData!)
        
        self.placeholderNoData?.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 140)
    }
    
    func removePlaceholderNoData() {
        if self.placeholderNoData != nil {
            self.placeholderNoData?.removeFromSuperview()
            self.placeholderNoData = nil
        }
    }
    
    // MARK: IBActions
    @IBAction func segmentChanged(_ sender: Any) {
        self.displayManager.showDataBySegment(displayOrderType: OrdersModel.DisplayOrderType(rawValue: self.segmentController.selectedSegmentIndex)!)
    }
    
    @IBAction func handleTouchDeleteButton(_ sender: Any) {
        self.pickerViewManager.showPickerViewWithDarkening()
    }
    
    // MARK: private methods
    private func subscribeOnEvents() {
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserSignOut)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onCanceledOrdersLoaded), name: .CanceledOrdersLoaded)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.onDealsOrdersLoaded), name: .DealsOrdersLoaded)
    }
    
    @objc private func updateDisplayInfo() {
        self.displayManager.reloadData()
    }
    
    @objc private func onCanceledOrdersLoaded() {
        self.displayManager.setCanceledOrders(orders: AppDelegate.session.getCanceledOrders())
        self.displayManager.reloadData()
    }

    @objc private func onDealsOrdersLoaded() {
        self.displayManager.setDealsOrders(orders: AppDelegate.session.getDealsOrders())
        self.displayManager.reloadData()
    }
}
