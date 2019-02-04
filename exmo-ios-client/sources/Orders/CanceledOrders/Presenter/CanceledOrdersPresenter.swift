//
//  CancelledOrdersCancelledOrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 25/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class CancelledOrdersPresenter: CancelledOrdersModuleInput, CancelledOrdersViewOutput, CancelledOrdersInteractorOutput {

    weak var view: CancelledOrdersViewInput!
    var interactor: CancelledOrdersInteractorInput!
    var router: CancelledOrdersRouterInput!

    func viewIsReady() {

    }
}
