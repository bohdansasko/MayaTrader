//
//  MoreMoreInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class MoreModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var moreViewController: MoreViewController!

    override func awakeFromNib() {

        let configurator = MoreModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: moreViewController)
    }

}
