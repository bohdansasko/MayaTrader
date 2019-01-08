//
//  CreateAlertCreateAlertPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class CreateAlertPresenter {
    weak var view: CreateAlertViewInput!
    var interactor: CreateAlertInteractorInput!
    var router: CreateAlertRouterInput!
}

// @MARK: CreateAlertModuleInput
extension CreateAlertPresenter: CreateAlertModuleInput {
    func setEditAlert(_ alert: Alert) {
        view.setEditAlert(alert)
    }
}

// @MARK: CreateAlertViewOutput
extension CreateAlertPresenter: CreateAlertViewOutput {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }
    
    func handleTouchOnCancelBtn() {
        router.close(uiViewController: view as? UIViewController)
    }
    
    func handleTouchButtonCreate(alertModel: Alert, operationType: AlertOperationType) {
        switch operationType {
        case .Add: interactor.createAlert(alertModel)
        case .Update: interactor.updateAlert(alertModel)
        }
    }
    
    func showSearchViewController(searchType: SearchViewController.SearchType) {
        router.openCurrencyPairsSearchView(view as! UIViewController, moduleOutput: self)
    }
}

// @MARK: CreateAlertInteractorOutput
extension CreateAlertPresenter: CreateAlertInteractorOutput {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        view.updateSelectedCurrency(tickerCurrencyPair)
    }
    
    func onCreateAlertSuccessful() {
        view.alertCreated()
    }

    func showAlert(message: String) {
        view.showAlert(message: message)
    }
}

// @MARK: SearchModuleOutput
extension CreateAlertPresenter: SearchModuleOutput {
    func onDidSelectCurrencyPair(rawName: String) {
        interactor.handleSelectedCurrency(rawName: rawName)
    }
}
