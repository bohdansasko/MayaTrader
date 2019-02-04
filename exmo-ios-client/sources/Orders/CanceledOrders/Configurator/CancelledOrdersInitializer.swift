//
//  CancelledOrdersCancelledOrdersInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 25/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CancelledOrdersModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var cancelledordersViewController: CancelledOrdersViewController!

    override func awakeFromNib() {

        let configurator = CancelledOrdersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: cancelledordersViewController)
    }

}
