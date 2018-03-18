//
//  WalletWalletRouterInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol WalletRouterInput {
    func openWalletSettings(viewController: UIViewController, data: SegueBlock?)
    func sendDataToWalletSettings(segue: UIStoryboardSegue, sender: Any?)
}
