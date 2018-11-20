//
//  MainTabBarModuleInitializer.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class MainTabBarModuleInitializer {
    var tabBarController: MainTabBarController!
    
    init() {
        tabBarController = MainTabBarController()
        configure()
    }
    
    private func configure() {
        let presenter = MainTabBarPresenter()
        tabBarController.output = presenter
        
        let interactor = MainTabBarInteractor()
        interactor.output = presenter
        interactor.networkWorker = ExmoLoginNetworkWorker()
        interactor.dbManager = RealmDatabaseManager()
        
        presenter.view = tabBarController
        presenter.interactor = interactor
        
    }
}
