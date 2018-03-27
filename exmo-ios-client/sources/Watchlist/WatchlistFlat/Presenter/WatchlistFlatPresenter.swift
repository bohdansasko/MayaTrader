//
//  WatchlistFlatWatchlistFlatPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class WatchlistFlatPresenter: WatchlistFlatModuleInput, WatchlistFlatViewOutput, WatchlistFlatInteractorOutput {

    weak var view: WatchlistFlatViewInput!
    var interactor: WatchlistFlatInteractorInput!
    var router: WatchlistFlatRouterInput!

    func viewIsReady() {

    }
}
