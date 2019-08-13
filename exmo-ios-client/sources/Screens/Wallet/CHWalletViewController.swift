//
//  CHWalletViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWalletViewController: CHBaseViewController, CHBaseViewControllerProtocol {
    typealias ContentView = CHWalletView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "TAB_WALLET".localized
    }

}
