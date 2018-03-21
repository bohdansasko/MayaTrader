//
//  MoreMoreViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, MoreViewInput {
    @IBOutlet weak var tableView: UITableView!
    
    var output: MoreViewOutput!
    var displayManager: MoreDataDisplayManager!
    
    // MARK: Life cycle
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }


    // MARK: MoreViewInput
    func setupInitialState() {
        displayManager.setTableView(tableView: tableView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDisplayInfo), name: .UserLogout, object: nil)
    }
    
    @objc func updateDisplayInfo() {
        displayManager.updateInfo()
    }
}
