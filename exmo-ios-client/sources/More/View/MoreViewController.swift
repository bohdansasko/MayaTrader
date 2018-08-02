//
//  MoreMoreViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class MoreViewController: ExmoUIViewController, MoreViewInput {
    @IBOutlet weak var tableView: UITableView!
    
    var output: MoreViewOutput!
    var displayManager: MoreDataDisplayManager!
    
    // MARK: Life cycle
    deinit {
        AppDelegate.notificationController.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }


    // MARK: MoreViewInput
    func setupInitialState() {
        displayManager.setTableView(tableView: tableView)
        
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserSignIn)
        AppDelegate.notificationController.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserSignOut)
    }
    
    @objc func updateDisplayInfo() {
        displayManager.updateInfo()
    }
}
