//
//  RootTabsModuleInitializer.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class RootTabsModuleInitializer {
    var tabBarController: RootTabsController!
    
    init() {
        tabBarController = RootTabsController()
        configure()
    }
    
    private func configure() {
        let presenter = RootTabsPresenter()
        tabBarController.output = presenter
        
        let interactor = RootTabsInteractor()
        interactor.output = presenter
        interactor.networkWorker = ExmoLoginNetworkWorker()
        interactor.dbManager = RealmDatabaseManager()
        
        presenter.view = tabBarController
        presenter.interactor = interactor
        
    }
}
