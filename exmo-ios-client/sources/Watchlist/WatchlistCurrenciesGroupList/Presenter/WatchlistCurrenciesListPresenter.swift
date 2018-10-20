//
//  WatchlistCurrenciesListWatchlistCurrenciesListPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class WatchlistCurrenciesListPresenter: WatchlistCurrenciesListModuleInput, WatchlistCurrenciesListViewOutput, WatchlistCurrenciesListInteractorOutput {

    weak var view: WatchlistCurrenciesListViewInput!
    var interactor: WatchlistCurrenciesListInteractorInput!
    var router: WatchlistCurrenciesListRouterInput!

    func viewIsReady() {
        // do nothing
    }
    
    func closeVC() {
        router.closeVC(vc: view as! UIViewController)
    }
    
    func handleTouchCell(listGroupModel: WatchlistCurrenciesListGroup) {
        router.openCurrenciesListWithCurrenciesRelativeTo(vc: view as! UIViewController, listGroupModel: listGroupModel)
    }
}
