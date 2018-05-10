//
//  OrdersManagerOrdersManagerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

enum DisplayOrderType: Int {
    case Opened = 0
    case Canceled
    case Deals
}

class OrdersManagerViewController: ExmoUIViewController, OrdersManagerViewInput {
    
    var output: OrdersManagerViewOutput!
    var currentViewController: UIViewController?
    var pickerViewManager: DarkeningPickerViewManager!
    var displayManager: OrdersDisplayManager!
    
    // @IBOutlets
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewIsReady()
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar(shouldHideNavigationBar: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateNavigationBar(shouldHideNavigationBar: false)
    }
    
    // MARK: OrdersManagerViewInput
    func setupInitialState() {
        displayManager.setTableView(tableView: self.tableView)
        displayManager.showDataBySegment(displayOrderType: .Opened)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        displayManager.showDataBySegment(displayOrderType: DisplayOrderType(rawValue: self.segmentController.selectedSegmentIndex)!)
    }
    
    @IBAction func handleTouchDeleteButton(_ sender: Any) {
        pickerViewManager.showPickerViewWithDarkening()
    }
}
