//
//  WatchlistFlatWatchlistFlatViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFlatViewController: UIViewController, WatchlistFlatViewInput {

    var output: WatchlistFlatViewOutput!
    var displayManager: WatchlistFlatDisplayManager!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        displayManager.setTableView(tableView: tableView)
    }


    // MARK: WatchlistFlatViewInput
    func setupInitialState() {
        //
    }
}
