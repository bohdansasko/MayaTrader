//
//  OrdersOrdersInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var ordersViewController: OrdersViewController!

    override func awakeFromNib() {

        let configurator = OrdersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: ordersViewController)
    }

}
