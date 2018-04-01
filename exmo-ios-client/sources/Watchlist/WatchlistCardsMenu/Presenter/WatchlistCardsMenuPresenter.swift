//
//  WatchlistCardsMenuWatchlistCardsMenuPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 30/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class WatchlistCardsMenuPresenter: WatchlistCardsMenuModuleInput, WatchlistCardsMenuViewOutput, WatchlistCardsMenuInteractorOutput {

    weak var view: WatchlistCardsMenuViewInput!
    var interactor: WatchlistCardsMenuInteractorInput!
    var router: WatchlistCardsMenuRouterInput!

    func viewIsReady() {

    }
}
