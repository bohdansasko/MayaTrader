//
//  RootTabsPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class RootTabsPresenter {
    weak var view: RootTabsViewInput!
    var interactor: RootTabsInteractorInput!
    
}

// MARK: RootTabsPresenterInput
extension RootTabsPresenter: RootTabsPresenterInput {
    
}

// MARK: RootTabsPresenterInput
extension RootTabsPresenter: RootTabsInteractorOutput {
    
}

// MARK: RootTabsViewOutput
extension RootTabsPresenter: RootTabsViewOutput {
    func viewIsReady() {
        // do nothing
    }
    
}
