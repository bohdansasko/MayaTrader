//
//  RootTabsModuleInitializer.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import UIKit

class RootTabsModuleInitializer: ModuleInitializer {
    var viewController: UIViewController!
    
    init() {
        let rootViewController = RootTabsController()
        viewController = rootViewController
        
        let presenter = RootTabsPresenter()
        presenter.view = rootViewController
        
        rootViewController.output = presenter
        
        let interactor = RootTabsInteractor()
        interactor.output = presenter
        interactor.networkWorker = ExmoLoginNetworkWorker()
        interactor.dbManager = RealmDatabaseManager()
        
        presenter.interactor = interactor
        
        rootViewController.initializingFinished()
    }
}
