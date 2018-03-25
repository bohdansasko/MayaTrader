//
//  CanceledOrdersCanceledOrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 25/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class CanceledOrdersPresenter: CanceledOrdersModuleInput, CanceledOrdersViewOutput, CanceledOrdersInteractorOutput {

    weak var view: CanceledOrdersViewInput!
    var interactor: CanceledOrdersInteractorInput!
    var router: CanceledOrdersRouterInput!

    func viewIsReady() {

    }
}
