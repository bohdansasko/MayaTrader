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
        print("handleTouchAddAlertBtn")
    }
    
    func handleTouchOnCancelBtn() {
        router.close(uiViewController: view as! UIViewController)
    }
    
    func showSearchViewController(searchType: SearchViewController.SearchType) {
        switch searchType {
        case .Currency:
            router.openCurrencyPairsSearchView(uiViewController: view as! UIViewController)
            print("Currency")
            break
        case .Sound:
            router.openSoundsSearchView(uiViewController: view as! UIViewController)
            print("Sound")
            break
        default:
            break
        }
    }
}
