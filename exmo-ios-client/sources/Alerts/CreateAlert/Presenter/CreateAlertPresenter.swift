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
    
    func showSearchViewController(searchType: SearchCurrencyPairViewController.SearchType) {
        switch searchType {
        case .Currencies:
            self.interactor.showCurrenciesSearchView()
            break
        case .Sounds:
            self.interactor.showSoundsSearchView()
            break
        default:
            break
        }
    }
    
    func showSearchViewController(searchType: SearchCurrencyPairViewController.SearchType, data: [SearchModel]) {
        switch searchType {
        case .Currencies:
            router.openCurrencyPairsSearchView(data: data, uiViewController: view as! UIViewController, callbackOnSelectCurrency: {
                (currencyId) in
                print("Currency")
                self.interactor.handleSelectedCurrency(currencyId: currencyId)
            })
            break
        case .Sounds:
            self.router.openSoundsSearchView(data: data, uiViewController: view as! UIViewController, callbackOnSelectSound: {
                (soundId) in
                self.interactor.handleSelectedSound(soundId: soundId)
            })
            print("Sound")
            break
        default:
            break
        }
    }
    
    func showCurrenciesSearchView(data: [SearchCurrencyPairModel]) {
        showSearchViewController(searchType: .Currencies, data: data)
    }
    
    func showSoundsSearchView(data: [SearchModel]) {
        showSearchViewController(searchType: .Sounds, data: data)
    }
    
    func updateSelectedCurrency(name: String, price: Double) {
        self.view.updateSelectedCurrency(name: name, price: price)
    }
    
    func updateSelectedSoundInUI(soundName: String) {
        self.view.updateSelectedSoundInUI(soundName: soundName)
    }
}
