////
////  MoreMenuPresenter.swift
////  ExmoMobileClient
////
////  Created by TQ0oS on 27/02/2018.
////  Copyright © 2018 Roobik. All rights reserved.
////
//import UIKit
//
//class MenuPresenter {
//    weak var view: TableMenuViewInput!
//    var interactor: MenuInteractorInput!
//    var router: MenuRouterInput!
//}
//
//// MARK: TableMenuViewOutput
//extension MenuPresenter: TableMenuViewOutput {
//    func viewIsReady() {
//        interactor.viewIsReady()
//    }
//    
//    func didTouchCell(type: CHMenuCellType) {
//        if type == .security && Defaults.isPasscodeActive() {
//            Defaults.resetPasscode()
//            view.updateCell(type: type)
//            view.showAlert("Your passcode has disabled.")
//        } else if let viewController = view as? UIViewController {
//            router.showViewController(sourceVC: viewController, touchedCellType: type)
//        }
//    }
//
//    func setIsAdsPresent(_ isAdsActive: Bool) {
//        view.setIsAdsPresent(isAdsActive)
//    }
//}
//
//// MARK: MenuInteractorOutput
//extension MenuPresenter: MenuInteractorOutput {
//    func onUserLogInOut(isLoggedUser: Bool) {
//        view.updateLayoutView(isLoggedUser: isLoggedUser)
//    }
//}
//
//// MARK: MenuRouterOutput
//extension MenuPresenter: MenuRouterOutput {
//    func userLogout() {
//        interactor.logout()
//    }
//}
