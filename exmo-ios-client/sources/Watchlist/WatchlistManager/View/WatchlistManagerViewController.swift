//
//  WatchlistManagerWatchlistManagerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistManagerViewController: UIViewController, WatchlistManagerViewInput {

    var output: WatchlistManagerViewOutput!
    private var currentViewController: UIViewController!
    
    @IBOutlet weak var menuSwitchController: UISwitch!
    @IBOutlet weak var viewContainer: UIView!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        setupInitialState()
    }


    // MARK: WatchlistManagerViewInput
    func setupInitialState() {
        let vc = self.viewControllerForSegmentIndex(isOn: self.menuSwitchController.isOn)
        
        self.addChildViewController(vc)
        vc.view.frame = viewContainer.bounds
        viewContainer.addSubview(vc.view)
        currentViewController = vc
    }
    
    
    @IBAction func menuSwitched(_ sender: Any) {
        let vc = self.viewControllerForSegmentIndex(isOn: self.menuSwitchController.isOn)
        
        self.addChildViewController(vc)
        self.transition(
            from: self.currentViewController!, to: vc,
            duration: 0.5, options: .showHideTransitionViews,
            animations: {
                self.currentViewController?.view.isHidden = true
                vc.view.frame = self.viewContainer.bounds
                self.viewContainer.addSubview(vc.view)
            },
            completion: { _ in
                vc.didMove(toParentViewController: self)
                self.currentViewController?.removeFromParentViewController()
                self.currentViewController = vc
            }
        )
        
    }
    
    func viewControllerForSegmentIndex(isOn: Bool) -> UIViewController {
        return isOn
            ? (self.storyboard?.instantiateViewController(withIdentifier: "WatchlistFlatViewController"))!
            : (self.storyboard?.instantiateViewController(withIdentifier: "WatchlistCardsMenuViewController"))!
    }
}
