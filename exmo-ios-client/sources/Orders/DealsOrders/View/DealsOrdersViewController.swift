//
//  DealsOrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class DealsOrdersViewController: UIViewController, DealsOrdersViewInput {

    var output: DealsOrdersViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: DealsOrdersViewInput
    func setupInitialState() {
    }
}
