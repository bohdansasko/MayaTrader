//
//  WalletWalletViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit.UITableView

protocol WalletViewInput: class {
    func setTouchEnabled(isTouchEnabled: Bool)
}

protocol WalletViewOutput {
    func viewIsReady()
    func openWalletSettings(segueBlock: SegueBlock?)
    func sendDataToWalletSettings(segue: UIStoryboardSegue, sender: Any?)
}
