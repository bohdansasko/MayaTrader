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

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: CreateAlertViewInput
    func setupInitialState() {
        // do nothing
    }
    
    //
    // @MARK: 
    //
    @IBAction func handleTouchOnCancelBtn(_ sender: Any) {
        output.handleTouchOnCancelBtn()
    }
    
    @IBAction func handleTouchAddAlertBtn(_ sender: Any) {
        // do nothing
    }
    
}
