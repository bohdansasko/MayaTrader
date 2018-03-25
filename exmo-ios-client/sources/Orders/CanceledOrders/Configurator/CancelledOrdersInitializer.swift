//
//  CanceledOrdersCanceledOrdersInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 25/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CanceledOrdersModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var cancelledordersViewController: CanceledOrdersViewController!

    override func awakeFromNib() {

        let configurator = CanceledOrdersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: cancelledordersViewController)
    }

}
