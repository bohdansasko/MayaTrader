//
//  CreateOrderCreateOrderRouterInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol CreateOrderRouterInput {
    func closeView(view: UIViewController)
    func openCurrencySearchVC(_ sourceVC: UIViewController, moduleOutput: SearchModuleOutput!)
}
