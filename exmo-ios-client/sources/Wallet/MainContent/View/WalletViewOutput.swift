//
//  WalletWalletViewOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 28/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import Foundation
import UIKit.UITableView

protocol WalletViewOutput {
    func viewIsReady(tableView: UITableView!)
    func openWalletSettings()
    func sendDataToWalletSettings(segue: UIStoryboardSegue, sender: Any?)
    func handleViewWillAppear()
}
