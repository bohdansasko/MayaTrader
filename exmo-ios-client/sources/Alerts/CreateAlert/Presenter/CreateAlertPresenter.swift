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
    
    func handleTouchAddAlertBtn(alertModel: AlertItem) {
        // TODO: send request to server on create alert
    }
    
    func handleTouchOnCancelBtn() {
        router.close(uiViewController: view as! UIViewController)
    }

    func handleTouchOnCurrencyPairView() {
        router.openCurrencyPairsSearchView(uiViewController: view as! UIViewController)
    }

    func handleTouchOnSoundView() {
        router.openSoundsSearchView(uiViewController: view as! UIViewController)
    }
}
