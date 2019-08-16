//
//  CurrenciesListModuleConfigurator.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 10/21/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class CurrenciesListModuleConfigurator {
    var viewController: CurrenciesListViewController!
    
    init() {
        configure()
    }
    
    private func configure() {
        viewController = CurrenciesListViewController()
        
        let presenter = CurrenciesListPresenter()
        let interactor = CurrenciesListInteractor()
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.interactor = interactor
        
        interactor.output = presenter
        interactor.networkWorker = TickerNetworkWorker()
        interactor.filterGroupController = ExmoFilterGroupController()
        interactor.dbManager = RealmDatabaseManager.shared
    }
}
