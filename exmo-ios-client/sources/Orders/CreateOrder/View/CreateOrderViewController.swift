//
//  CreateOrderCreateOrderViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderViewController: UIViewController, CreateOrderViewInput {
    var output: CreateOrderViewOutput!
    var dataDisplayManager: CreateOrderDisplayManager!
    var pickerViewManager: DarkeningPickerViewManager!

    var shouldBeginEditing = true
    
    // IBOutles
    @IBOutlet weak var textFieldSelectedMarketType: UITextField!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()

        setupInitialState()
        
        // createPickerView()
    }

    // MARK: CreateOrderViewInput
    func setupInitialState() {
        // do nothing
    }
    
    @IBAction func handleTouchFromOrderByButton(_ sender: Any) {
        self.pickerViewManager.showPickerViewWithDarkening()
    }
    
    @IBAction func handleTouchOnCancelButton(_ sender: Any) {
        self.output.handleTouchOnCancelButton()
    }
}

