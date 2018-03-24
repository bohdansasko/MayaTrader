//
//  OrdersManagerOrdersManagerViewController.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersManagerViewController: UIViewController, OrdersManagerViewInput {
    
    var output: OrdersManagerViewOutput!
    var currentViewController: UIViewController?
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var viewContainer: UIView!
    
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
        
        guard let vc = self.viewControllerForSegmentIndex(index: self.segmentController.selectedSegmentIndex) else { return }
        
        self.addChildViewController(vc)
        vc.view.frame = viewContainer.bounds
        viewContainer.addSubview(vc.view)
        currentViewController = vc
    }

    @IBAction func segmentChanged(_ sender: Any) {
        guard let vc = self.viewControllerForSegmentIndex(index: self.segmentController.selectedSegmentIndex) else {
            return
        }
        
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
    
    // MARK: OrdersManagerViewInput
    func setupInitialState() {
        // do nothing
    }
    
    func viewControllerForSegmentIndex(index: Int) -> UIViewController? {
        switch index {
        case 0: return self.storyboard?.instantiateViewController(withIdentifier: "ActiveOrdersViewController")
        case 1: return self.storyboard?.instantiateViewController(withIdentifier: "HistoryOrdersViewController")
        default:
            return nil
        }
    }
}
