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

class CurrenciesListPresenter: CurrenciesListModuleInput, CurrenciesListViewControllerOutput, CurrenciesListInteractorOutput {
    weak var view: CurrenciesListViewControllerInput!
    var interactor: CurrenciesListInteractorInput!
    
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func onDidLoadCurrenciesPairs(items: [WatchlistCurrency]) {
        view.onDidLoadCurrenciesPairs(items: items)
    }

    func updateFavPairs(items: [WatchlistCurrency]) {
        view.updateFavPairs(items: items)
    }

    func setSegueBlock(_ segueBlock: SegueBlock) {
        guard let segueBlock = segueBlock as? CurrenciesGroupsGroupSegueBlock else { return }
        view.setTitle(segueBlock.groupModel!.name)
        interactor.setCurrencyGroupName(segueBlock.groupModel!.name)
    }
    
    func handleTouchFavBtn(datasourceItem: Any?, isSelected: Bool) {
        interactor.cacheFavCurrencyPair(datasourceItem: datasourceItem, isSelected: isSelected)
    }
    
    func viewWillDisappear() {
        interactor.viewWillDisappear()
    }
}
