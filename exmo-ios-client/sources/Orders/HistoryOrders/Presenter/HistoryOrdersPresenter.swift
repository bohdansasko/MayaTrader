//
//  HistoryOrdersHistoryOrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class HistoryOrdersPresenter: HistoryOrdersModuleInput, HistoryOrdersViewOutput, HistoryOrdersInteractorOutput {

    weak var view: HistoryOrdersViewInput!
    var interactor: HistoryOrdersInteractorInput!
    var router: HistoryOrdersRouterInput!

    func viewIsReady() {

    }
}
