//
//  WatchlistFavouriteCurrenciesViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistFavouriteCurrenciesViewController: ExmoUIViewController, WatchlistFavouriteCurrenciesViewInput {

    var output: WatchlistFavouriteCurrenciesViewOutput!
    
    @IBOutlet weak var menuSwitchController: UISwitch!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }


    // MARK: WatchlistFavouriteCurrenciesViewInput
    func setupInitialState() {
        let vc = self.viewControllerForSegmentIndex(isOn: self.menuSwitchController.isOn)
    }
    
    
    @IBAction func menuSwitched(_ sender: Any) {
        let vc = self.viewControllerForSegmentIndex(isOn: self.menuSwitchController.isOn)
        
    }
    
    func viewControllerForSegmentIndex(isOn: Bool) -> UIViewController? {
        return isOn
            ? nil
            : nil
    }
}
