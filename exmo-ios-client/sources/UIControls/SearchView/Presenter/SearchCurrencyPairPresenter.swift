//
//  SearchPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class SearchPresenter {
    weak var view: SearchViewInput!
    var interactor: SearchInteractorInput!
    var router: SearchRouterInput!
    weak var moduleOutput: SearchModuleOutput?
    
    deinit {
        print("deinit \(String(describing: self))")
    }
}

// MARK: SearchInteractorOutput
extension SearchPresenter: SearchModuleInput {
    func setInputModule(output: SearchModuleOutput?) {
        moduleOutput = output
    }
}

// MARK: SearchInteractorOutput
extension SearchPresenter: SearchViewOutput {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }
    
    func closeVC() {
        if let viewController = view as? UIViewController {
            router.closeView(uiViewController: viewController)
        }
    }
    
    func onTouchCurrencyPair(rawName: String) {
        moduleOutput?.onDidSelectCurrencyPair(rawName: rawName)
        closeVC()
    }
}

// MARK: SearchInteractorOutput
extension SearchPresenter: SearchInteractorOutput {
    func onDidLoadCurrenciesPairs(_ pairs: [SearchCurrencyPairModel]) {
        view.updatePairsList(pairs)
    }
}
