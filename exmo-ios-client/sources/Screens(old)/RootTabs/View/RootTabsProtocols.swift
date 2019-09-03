//
//  RootTabsProtocols.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol RootTabsViewInput: class {
    
}

protocol RootTabsViewOutput {
    func viewDidLoad()
    func viewWillAppear()
}
