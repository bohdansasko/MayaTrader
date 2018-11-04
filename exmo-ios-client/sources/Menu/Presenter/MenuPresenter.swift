//
//  MoreMenuPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class MenuPresenter: MenuModuleInput, TableMenuViewOutput, MenuInteractorOutput, MenuRouterOutput {

    weak var view: TableMenuViewInput!
    var interactor: MenuInteractorInput!
    var router: MenuRouterInput!
}

// @MARK: TableMenuViewOutput
extension MenuPresenter {
    func viewIsReady() {
        interactor.viewIsReady()
    }
    
    func didTouchCell(type: MenuCellType) {
        router.showViewController(sourceVC: view as! UIViewController, touchedCellType: type)
    }
}

// @MARK: MenuInteractorOutput
extension MenuPresenter {
    func onUserLogInOut(isLoggedUser: Bool) {
        view.updateLayoutView(isLoggedUser: isLoggedUser)
    }
}

// @MARK: MenuRouterOutput
extension MenuPresenter {
    func userLogout() {
        interactor.logout()
    }
}
