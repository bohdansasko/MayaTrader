//
//  WatchlistManagerWatchlistManagerPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class WatchlistManagerPresenter: WatchlistManagerModuleInput, WatchlistManagerViewOutput, WatchlistManagerInteractorOutput {

    weak var view: WatchlistManagerViewInput!
    var interactor: WatchlistManagerInteractorInput!
    var router: WatchlistManagerRouterInput!

    func viewIsReady() {

    }
}
