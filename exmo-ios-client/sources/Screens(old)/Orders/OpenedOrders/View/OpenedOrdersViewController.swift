//
//  OrdersOrdersViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OpenedOrdersViewController: UIViewController, OpenedOrdersViewInput {
    
    var output: OpenedOrdersViewOutput!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }

    
    // MARK: OrdersViewInput
    func setupInitialState() {
        // do nothing
    }
}
