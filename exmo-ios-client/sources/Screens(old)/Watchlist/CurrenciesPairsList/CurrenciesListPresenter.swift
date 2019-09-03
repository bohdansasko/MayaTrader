//
//  CurrenciesListPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

protocol CurrenciesListModuleInput {
    func setSegueBlock(_ sequeBlock: SegueBlock)
}

class CurrenciesListPresenter  {
    weak var view: CurrenciesListViewControllerInput!
    var interactor: CurrenciesListInteractorInput!
}

extension CurrenciesListPresenter: CurrenciesListModuleInput {
    func setSegueBlock(_ segueBlock: SegueBlock) {
        guard let segueBlock = segueBlock as? CurrenciesGroupsGroupSegueBlock else { return }
        view.setTitle(segueBlock.groupModel!.name)
        interactor.setCurrencyGroupName(segueBlock.groupModel!.name)
    }
}

extension CurrenciesListPresenter:  CurrenciesListViewControllerOutput {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func handleTouchFavBtn(datasourceItem: Any?, isSelected: Bool) {
        interactor.cacheFavCurrencyPair(datasourceItem: datasourceItem, isSelected: isSelected)
    }
    
    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }
}

extension CurrenciesListPresenter: CurrenciesListInteractorOutput {
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency]) {
        view.onDidLoadCurrenciesPairs(items: items)
    }
    
    func updateFavPairs(items: [WatchlistCurrency]) {
        view.updateFavPairs(items: items)
    }
    
    func onMaxAlertsSelectedError(msg: String) {
        view.showAlert(msg: msg)
    }
}
