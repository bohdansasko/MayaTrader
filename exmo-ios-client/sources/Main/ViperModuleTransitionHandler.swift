//
//  ViperModuleTransitionHandler.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/24/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol ConfigurationBlock: class {
    // do nothing
}

extension UIViewController {
    func openModule(segueIdentifier: String, block: ConfigurationBlock?) {
        self.performSegue(withIdentifier: segueIdentifier, sender: block)
    }
}
