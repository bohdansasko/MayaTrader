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
        subscribeOnEvents()
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
    
    // MARK: private methods
    private func subscribeOnEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
    }
    
    @objc private func updateDisplayInfo() {
        self.displayManager.reloadData()
    }
}
