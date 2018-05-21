//
//  MenuItem.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 2/27/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class MenuItem {
    enum RightViewOptions {
        case None
        case Empty
        case Icon
        case Text
    }
    
    var title: String
    var iconNamed: String
    var segueIdentifier: String
    var action: VoidClosure? = nil
    var rightViewOptions = RightViewOptions.None
    var rightText: String? = nil
    
    init(title: String, iconNamed: String, segueIdentifier: String, rightViewOptions: RightViewOptions = MenuItem.RightViewOptions.Icon, rightText: String? = nil) {
        self.title = title
        self.iconNamed = iconNamed
        self.segueIdentifier = segueIdentifier
        self.rightText = rightText
        self.rightViewOptions = rightViewOptions
    }

    convenience init(title: String, iconNamed: String, rightViewOptions: RightViewOptions, action: VoidClosure?) {
        self.init(title: title, iconNamed: iconNamed,  segueIdentifier: "", rightViewOptions: rightViewOptions)
        self.action = action
    }

    func isSegueItem() -> Bool {
        return segueIdentifier.isEmpty != true
    }

    func doAction() {
        self.action?()
    }
}
