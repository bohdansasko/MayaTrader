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
    let dataDisplayManager = MoreDataDisplayManager()
    let reuseIdentifier = "MenuItemTableViewCell"
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        tableView.delegate = self
        tableView.dataSource = self
    }


    // MARK: MoreViewInput
    func setupInitialState() {
        // do nothing
    }
}

extension MoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataDisplayManager.getCountMenuItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItem = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as! MenuItemTableViewCell
        menuItem.setTitleLabel(text: self.dataDisplayManager.getMenuItemName(byRow: indexPath.row))
        return menuItem
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segueIdentifier = dataDisplayManager.getMenuItemSegueIdentifier(byRow: indexPath.row)
        output.onDidSelectMenuItem(viewController: self, segueIdentifier: segueIdentifier)
    }
}
