//
//  CreateOrderCreateOrderViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderViewController: UITableViewController, CreateOrderViewInput {
    var output: CreateOrderViewOutput!
    var dataDisplayManager: CreateOrderDisplayManager!
    var pickerViewManager: DarkeningPickerViewManager!
    
    // IBOutles
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()

        setupInitialState()
    }

    // MARK: CreateOrderViewInput
    func setupInitialState() {
        self.dataDisplayManager.setTableView(tableView: self.tableView)
        
        configureCancelButton()
        
        self.pickerViewManager.setCallbackOnSelectAction(callback: { actionIndex in
            self.dataDisplayManager.handleSelectedAction(actionIndex: actionIndex)
        })
        
        // for hide keyboard on touch background
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func configureCancelButton() {
        self.cancelButton.setTitleTextAttributes([
                NSAttributedStringKey.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
                NSAttributedStringKey.foregroundColor: UIColor.orangePink
            ],
            for: .normal
        )
        self.cancelButton.setTitleTextAttributes([
                NSAttributedStringKey.font: UIFont.getExo2Font(fontType: .SemiBold, fontSize: 17),
                NSAttributedStringKey.foregroundColor: UIColor.orangePink
            ],
            for: .highlighted
        )
    }
    
    func showPickerView() {
        self.pickerViewManager.showPickerViewWithDarkening()
    }
    
    @IBAction func handleTouchOnCancelButton(_ sender: Any) {
        self.output.handleTouchOnCancelButton()
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        self.dataDisplayManager.updateSelectedCurrency(name: name, price: price)
    }
    
    func setOrderSettings(orderSettings: OrderSettings) {
        self.dataDisplayManager.setOrderSettings(orderSettings: orderSettings)
    }
}

