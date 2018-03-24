//
//  OrdersManagerOrdersManagerInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OrdersManagerModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var ordersmanagerViewController: OrdersManagerViewController!

    override func awakeFromNib() {

        let configurator = OrdersManagerModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: ordersmanagerViewController)
    }

}
