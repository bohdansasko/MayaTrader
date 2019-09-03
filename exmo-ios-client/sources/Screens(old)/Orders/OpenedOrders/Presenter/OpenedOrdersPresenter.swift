//
//  OrdersOrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class OpenedOrdersPresenter: OpenedOrdersModuleInput, OpenedOrdersViewOutput, OpenedOrdersInteractorOutput {

    weak var view: OpenedOrdersViewInput!
    var interactor: OpenedOrdersInteractorInput!
    var router: OpenedOrdersRouterInput!
    
    func viewIsReady() {
        // do nothing
    }
}
