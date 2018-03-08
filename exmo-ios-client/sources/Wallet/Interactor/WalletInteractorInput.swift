//
//  WalletWalletInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UITableView

@objc protocol WalletInteractorInput {
    func viewIsReady(tableView: UITableView!)
    func updateDisplayInfo()
}
