//
//  SearchCurrencyPairSearchCurrencyPairPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class SearchCurrencyPairPresenter: SearchCurrencyPairModuleInput, SearchCurrencyPairViewOutput, SearchCurrencyPairInteractorOutput {
    weak var view: SearchCurrencyPairViewInput!
    var interactor: SearchCurrencyPairInteractorInput!
    var router: SearchCurrencyPairRouterInput!
    
    private var callbackOnSelectCurrency: IntInVoidOutClosure? = nil
    
    func viewIsReady() {
        // do nothing
    }
    
    func handleCloseView() {
        self.router.closeView(uiViewController: view as! UIViewController)
    }
    
    func subscribeOnSelectCurrency(callback: IntInVoidOutClosure?) {
        self.callbackOnSelectCurrency = callback
    }
    
    func subscribeOnSelectCurrency(callback: @escaping IntInVoidOutClosure) {
        self.callbackOnSelectCurrency = callback
    }
    
    func handleTouchOnCurrency(currencyPairId: Int) {
        self.callbackOnSelectCurrency?(currencyPairId)
        self.handleCloseView()
    }
    
    func setSearchData(_ searchType: SearchCurrencyPairViewController.SearchType, _ data: [SearchModel]) {
        self.view.setSearchData(searchType, data)
    }
}
