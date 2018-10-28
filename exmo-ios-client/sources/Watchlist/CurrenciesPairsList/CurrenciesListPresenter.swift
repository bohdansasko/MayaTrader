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
    
    func onDidLoadTicker(tickerData: [String : TickerCurrencyModel]) {
        view.onDidLoadTicker(tickerData: tickerData)
    }
    
    func setSegueBlock(_ segueBlock: SegueBlock) {
        guard let segueBlock = segueBlock as? CurrenciesGroupsGroupSegueBlock else { return }
        interactor.setCurrencyGroupName(segueBlock.groupModel!.name)
    }
}
