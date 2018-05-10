//
//  AlertsAlertsViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class ExmoUIViewController : UIViewController {
    func updateNavigationBar(shouldHideNavigationBar: Bool) {
        let dummyImage: UIImage? = shouldHideNavigationBar ? UIImage() : nil
        
        self.navigationController?.navigationBar.setBackgroundImage(dummyImage, for: .default)
        self.navigationController?.navigationBar.shadowImage = dummyImage
        self.navigationController?.navigationBar.isTranslucent = shouldHideNavigationBar
    }
}

class AlertsViewController: ExmoUIViewController, AlertsViewInput {

    @IBOutlet weak var tableView: UITableView!
    
    var output: AlertsViewOutput!
    var displayManager: AlertDataDisplayManager!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateNavigationBar(shouldHideNavigationBar: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        updateNavigationBar(shouldHideNavigationBar: false)
    }
    

    // MARK: AlertsViewInput
    func setupInitialState() {
        // do nothing
        displayManager.setTableView(tableView: tableView)
    }
}
