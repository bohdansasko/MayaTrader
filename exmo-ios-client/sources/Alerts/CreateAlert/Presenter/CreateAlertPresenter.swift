//
//  CreateAlertCreateAlertPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class CreateAlertPresenter: CreateAlertModuleInput {
    weak var view: CreateAlertViewInput!
    var interactor: CreateAlertInteractorInput!
    var router: CreateAlertRouterInput!
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
    
    func handleTouchAlertBtn(alertModel: Alert, operationType: AlertOperationType) {
        switch operationType {
        case .Add:
            interactor.createAlert(alertModel)
        case .Update:
            interactor.updateAlert(alertModel)
        default:
            // do nothing
            break
        }
        handleTouchOnCancelBtn()
    }
    
    func showSearchViewController(searchType: SearchViewController.SearchType) {
        router.openCurrencyPairsSearchView(view as! UIViewController, moduleOutput: self)
    }
    
    func setAlertData(alertItem: Alert) {
        view.setAlertItem(alertItem: alertItem)
        print("edit alertItem: \(alertItem.getDataAsText())")
    }
}

// @MARK: CreateAlertInteractorOutput
extension CreateAlertPresenter: CreateAlertInteractorOutput {
    func updateSelectedCurrency(_ tickerCurrencyPair: TickerCurrencyModel?) {
        view.updateSelectedCurrency(tickerCurrencyPair)
    }
    
    func closeView() {
        
    }
    
    func onCreateAlertSuccessull() {
        
    }
    
    func showAlert(message: String) {
        
    }
}

// @MARK: SearchModuleOutput
extension CreateAlertPresenter: SearchModuleOutput {
    func onDidSelectCurrencyPair(rawName: String) {
        interactor.handleSelectedCurrency(rawName: rawName)
    }
}
