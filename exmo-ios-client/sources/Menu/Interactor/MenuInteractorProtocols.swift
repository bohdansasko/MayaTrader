//
//  MoreMenuInteractorOutput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit.UIViewController

@objc protocol MenuInteractorInput {
    func viewIsReady()
}

protocol MenuInteractorOutput: class {
    func onUserLogInOut(isLoggedUser: Bool)
}
