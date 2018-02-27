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
    var segueIndentifier: String
    
    init(name: String, segueIndentifier: String) {
        self.name = name
        self.segueIndentifier = segueIndentifier
    }
}
