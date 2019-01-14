//
//  ModuleInitializer.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/15/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import UIKit.UIViewController

protocol ModuleInitializer {
    var viewController: UIViewController! { get }
}
