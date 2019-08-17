//
//  CHOrdersViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHOrdersViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHOrdersView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TAB_ORDERS".localized
    }
}
