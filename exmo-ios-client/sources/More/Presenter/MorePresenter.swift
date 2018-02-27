//
//  MoreMorePresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class MorePresenter: MoreModuleInput, MoreViewOutput, MoreInteractorOutput {

    weak var view: MoreViewInput!
    var interactor: MoreInteractorInput!
    var router: MoreRouterInput!

    func viewIsReady() {
        // do nothing
    }
    
    func onDidSelectMenuItem(viewController: UIViewController, segueIdentifier: String) {
        router.onDidSelectMenuItem(viewController: viewController, segueIdentifier: segueIdentifier)
    }
}
