//
//  CreateOrderCreateOrderInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateOrderModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var createOrderViewController: CreateOrderViewController!

    override func awakeFromNib() {

        let configurator = CreateOrderModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: createOrderViewController)
    }

}
