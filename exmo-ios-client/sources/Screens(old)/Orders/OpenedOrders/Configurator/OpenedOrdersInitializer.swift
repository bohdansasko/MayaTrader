//
//  OrdersOrdersInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class OpenedOrdersModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var ordersViewController: OpenedOrdersViewController!

    override func awakeFromNib() {

        let configurator = OpenedOrdersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: ordersViewController)
    }

}
