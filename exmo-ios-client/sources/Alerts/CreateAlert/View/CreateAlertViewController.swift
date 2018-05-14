//
//  CreateAlertCreateAlertViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertViewController: UIViewController, CreateAlertViewInput {

    var output: CreateAlertViewOutput!

    //
    // @MARK: outlets
    //
    @IBOutlet weak var currencyPairViewController: UITouchableViewWithIndicator!
    @IBOutlet weak var marketPriceTextField: UITextField!
    @IBOutlet weak var upperBoundTextField: UITextField!
    @IBOutlet weak var bottomBoundTextField: UITextField!
    @IBOutlet weak var commisionTextField: UITextField!
    @IBOutlet weak var soundViewController: UITouchableViewWithIndicator!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }


    // MARK: CreateAlertViewInput
    func setupInitialState() {
        currencyPairViewController.setCallbackOnTouch(callback: {
            self.output.handleTouchOnCurrencyPairView()
        })
        soundViewController.setCallbackOnTouch(callback: {
            self.output.handleTouchOnSoundView()
        })
    }
    
    //
    // @MARK: IBActions
    //
    @IBAction func handleTouchOnCancelBtn(_ sender: Any) {
        output.handleTouchOnCancelBtn()
    }
    
    @IBAction func handleTouchAddAlertBtn(_ sender: Any) {
        let currencyPairName = currencyPairViewController.contentText
        let currencyPairPriceAtCreateMoment = Double(marketPriceTextField.text!)
        let topBoundary = Double(upperBoundTextField.text!)
        let bottomBoundary = Double(bottomBoundTextField.text!)
        
        let alertModel = AlertItem(
                currencyPairName: currencyPairName, currencyPairPriceAtCreateMoment: currencyPairPriceAtCreateMoment,
                note: "", topBoundary: topBoundary, bottomBoundary: bottomBoundary,
                status: .Active, dateCreated: Date()
        )
        output.handleTouchAddAlertBtn(alertModel: alertModel)
    }
    
}
