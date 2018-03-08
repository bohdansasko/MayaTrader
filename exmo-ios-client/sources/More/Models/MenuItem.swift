//
//  MenuItem.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class MenuItem {
    var name: String
    var segueIdentifier: String
    var action: VoidClosure? = nil
    
    init(name: String, segueIdentifier: String) {
        self.name = name
        self.segueIdentifier = segueIdentifier
    }

    convenience init(name: String, action: VoidClosure?) {
        self.init(name: name, segueIdentifier: "")
        self.action = action
    }

    func isSegueItem() -> Bool {
        return segueIdentifier.isEmpty != true
    }

    func doAction() {
        self.action?()
    }
}
