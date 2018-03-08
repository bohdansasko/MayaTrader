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

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady(tableView: tableView)
    }


    // MARK: MoreViewInput
    func setupInitialState() {
        // do nothing
    }
}
