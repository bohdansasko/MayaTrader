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

class OrdersManagerViewController: UIViewController, OrdersManagerViewInput {
    
    var output: OrdersManagerViewOutput!
    var currentViewController: UIViewController?
    var pickerViewManager: DeleteOrdersPickerViewManager!
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
        displayManager.showDataBySegment(displayOrderType: .Opened)
    }
    
    // MARK: OrdersManagerViewInput
    func setupInitialState() {
        displayManager.setTableView(tableView: self.tableView)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        displayManager.showDataBySegment(displayOrderType: DisplayOrderType(rawValue: self.segmentController.selectedSegmentIndex)!)
    }
    
    @IBAction func handleTouchDeleteButton(_ sender: Any) {
        pickerViewManager.showPickerView()
    }
}
