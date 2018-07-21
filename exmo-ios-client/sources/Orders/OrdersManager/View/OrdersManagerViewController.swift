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
        NotificationCenter.default.removeObserver(self)
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
    }
    
    @objc private func updateDisplayInfo() {
        self.displayManager.reloadData()
    }
}
