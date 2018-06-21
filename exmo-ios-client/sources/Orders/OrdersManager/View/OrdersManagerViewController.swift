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
    

    // MARK: public methods
    func setupInitialState() {
        let segmentControlTextFont = UIFont(name: "Exo2-Regular", size: 13)
        self.segmentController.setTitleTextAttributes([
            NSAttributedStringKey.font: segmentControlTextFont!
            ], for: .normal)
        
        displayManager.setTableView(tableView: self.tableView)
        displayManager.showDataBySegment(displayOrderType: .Opened)
    }
    
    // MARK: IBActions
    @IBAction func segmentChanged(_ sender: Any) {
        displayManager.showDataBySegment(displayOrderType: OrdersModel.DisplayOrderType(rawValue: self.segmentController.selectedSegmentIndex)!)
    }
    
    @IBAction func handleTouchDeleteButton(_ sender: Any) {
        pickerViewManager.showPickerViewWithDarkening()
    }
}
