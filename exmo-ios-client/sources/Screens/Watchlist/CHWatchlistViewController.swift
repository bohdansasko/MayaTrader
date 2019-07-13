//
//  CHWatchlistViewController.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 7/13/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit

final class CHWatchlistViewController: CHViewController, CHViewControllerProtocol {
    typealias ContentView = CHWatchlistView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TAB_WATCHLIST".localized
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
