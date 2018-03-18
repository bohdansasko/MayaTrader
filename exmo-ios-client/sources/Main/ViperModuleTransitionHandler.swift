//
//  ViperModuleTransitionHandler.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/24/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

protocol SegueBlock: class {
    // do nothing
}

extension UIViewController {
    func openModule(segueIdentifier: String, block: SegueBlock?) {
        self.performSegue(withIdentifier: segueIdentifier, sender: block)
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
