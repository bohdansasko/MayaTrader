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
        if type == .Security && Defaults.isPasscodeActive() {
            Defaults.resetPasscode()
            view.updateCell(type: type)
            view.showAlert("Your passcode has disabled.")
        } else {
            router.showViewController(sourceVC: view as! UIViewController, touchedCellType: type)
        }
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
