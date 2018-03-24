//
//  OrdersManagerOrdersManagerPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 24/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

class OrdersManagerPresenter: OrdersManagerModuleInput, OrdersManagerViewOutput, OrdersManagerInteractorOutput {

    weak var view: OrdersManagerViewInput!
    var interactor: OrdersManagerInteractorInput!
    var router: OrdersManagerRouterInput!

    func viewIsReady() {

    }
}
