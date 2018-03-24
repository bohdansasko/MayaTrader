//
//  HistoryOrdersHistoryOrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class HistoryOrdersViewController: UIViewController, HistoryOrdersViewInput {

    var output: HistoryOrdersViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: HistoryOrdersViewInput
    func setupInitialState() {
    }
}
