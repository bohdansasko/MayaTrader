//
//  HistoryOrdersHistoryOrdersInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class HistoryOrdersModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var historyordersViewController: HistoryOrdersViewController!

    override func awakeFromNib() {

        let configurator = HistoryOrdersModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: historyordersViewController)
    }

}
