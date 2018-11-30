//
//  AlertsAlertsRouterInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 11/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UIViewController

protocol AlertsRouterInput {
    func showVCAddAlert(_ vc: UIViewController)
    func editAlert(view: UIViewController, alert: Alert) 
}
