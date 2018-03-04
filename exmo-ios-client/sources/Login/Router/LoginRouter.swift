//
//  LoginLoginRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 23/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class LoginRouter: LoginRouterInput {
    func showTabMoreWithLoginData(view: UIViewController) {
        view.navigationController?.popViewController(animated: true)
    }
}
