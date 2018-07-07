//
//  SearchPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class SearchPresenter: SearchModuleInput, SearchViewOutput, SearchInteractorOutput {
    weak var view: SearchViewInput!
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!
    
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
    
    func setSearchData(_ searchType: SearchViewController.SearchType, _ data: [SearchModel]) {
        self.view.setSearchData(searchType, data)
    }
}
