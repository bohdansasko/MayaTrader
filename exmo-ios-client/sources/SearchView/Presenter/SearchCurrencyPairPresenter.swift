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
    var moduleOutput: SearchModuleOutput?
    
    func viewIsReady() {
        // do nothing
    }
    
    func closeVC() {
        self.router.closeView(uiViewController: view as! UIViewController)
    }
    
    func onTouchCurrencyPair(rawName: String) {
        moduleOutput?.onDidSelectCurrencyPair(rawName: rawName)
        self.closeVC()
    }
    
    func setSearchData(_ searchType: SearchViewController.SearchType, _ data: [SearchModel]) {
//        self.view.setSearchData(searchType, data)
    }
    
    func setInputModule(output: SearchModuleOutput?) {
        moduleOutput = output
    }
}
