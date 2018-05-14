//
//  CreateAlertCreateAlertPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class CreateAlertPresenter: CreateAlertModuleInput, CreateAlertViewOutput, CreateAlertInteractorOutput {

    weak var view: CreateAlertViewInput!
    var interactor: CreateAlertInteractorInput!
    var router: CreateAlertRouterInput!

    func viewIsReady() {
        // do nothing
    }
    
    func handleTouchOnCancelBtn() {
        router.close(uiViewController: view as! UIViewController)
    }
}
