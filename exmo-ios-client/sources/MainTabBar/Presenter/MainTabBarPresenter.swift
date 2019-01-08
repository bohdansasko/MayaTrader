//
//  MainTabBarPresenter.swift
//  exmo-ios-client
//
//  Created by Bogdan Sasko on 11/10/18.
//  Copyright © 2018 Bogdan Sasko. All rights reserved.
//

import Foundation

class MainTabBarPresenter {
    weak var view: MainTabBarViewInput!
    var interactor: MainTabBarInteractorInput!
    
}

// @MARK: MainTabBarPresenterInput
extension MainTabBarPresenter: MainTabBarPresenterInput {
    
}

// @MARK: MainTabBarPresenterInput
extension MainTabBarPresenter: MainTabBarInteractorOutput {
    
}

// @MARK: MainTabBarViewOutput
extension MainTabBarPresenter: MainTabBarViewOutput {
    func viewIsReady() {
        interactor.login()
    }
    
}
