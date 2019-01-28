//
// Created by Bogdan Sasko on 1/28/19.
// Copyright (c) 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

class SubscriptionsPresenter {
    weak var view: SubscriptionsViewInput!
    var router: SubscriptionsRouterInput!
    var interactor: SubscriptionsInteractorInput!
}

extension SubscriptionsPresenter: SubscriptionsViewOutput {
    // do nothing
}

extension SubscriptionsPresenter: SubscriptionsInteractorOutput {
    // do nothing
}