//
//  DealsOrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class DealsOrdersPresenter: DealsOrdersModuleInput, DealsOrdersViewOutput, DealsOrdersInteractorOutput {

    weak var view: DealsOrdersViewInput!
    var interactor: DealsOrdersInteractorInput!
    var router: DealsOrdersRouterInput!

    func viewIsReady() {

    }
}
