//
//  MoreMenuPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 27/02/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

class MenuPresenter: MenuModuleInput, TableMenuViewOutput, MenuInteractorOutput {

    weak var view: TableMenuViewInput!
    var interactor: MenuInteractorInput!
    var router: MenuRouterInput!

    func viewIsReady() {
        // do nothing
    }
    
    func didTouchCell(type: MenuCellType) {
        router.showViewController(sourceVC: view as! UIViewController, touchedCellType: type)
    }
}
