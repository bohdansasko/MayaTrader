//
//  SubscriptionsModuleInitializer.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 1/27/19.
//  Copyright © 2019 Bogdan Sasko. All rights reserved.
//

import Foundation

final class SubscriptionsModuleInitializer: NSObject {
    @IBOutlet fileprivate weak var viewController: SubscriptionsViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let router = SubscriptionsRouter()
        let interactor = SubscriptionsInteractor()
        let presenter = SubscriptionsPresenter()

        viewController.output = presenter

        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter

    }
    
}
