//
//  OrdersOrdersPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 20/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class ActiveOrdersPresenter: ActiveOrdersModuleInput, ActiveOrdersViewOutput, ActiveOrdersInteractorOutput {

    weak var view: ActiveOrdersViewInput!
    var interactor: ActiveOrdersInteractorInput!
    var router: ActiveOrdersRouterInput!
    
    func viewIsReady() {
        // do nothing
    }
}
