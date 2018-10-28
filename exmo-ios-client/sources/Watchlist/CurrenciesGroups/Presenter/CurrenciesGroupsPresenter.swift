//
//  CurrenciesGroupsPresenter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit

protocol CurrenciesGroupsModuleInput: class {

}


class CurrenciesGroupsPresenter: CurrenciesGroupsModuleInput, CurrenciesGroupsViewOutput, CurrenciesGroupsInteractorOutput {

    weak var view: CurrenciesGroupsViewInput!
    var interactor: CurrenciesGroupsInteractorInput!
    var router: CurrenciesGroupsRouterInput!

    func viewIsReady() {
        // do nothing
    }
    
    func closeVC() {
        router.closeVC(vc: view as! UIViewController)
    }
    
    func handleTouchCell(listGroupModel: CurrenciesGroupsGroup) {
        router.openCurrenciesListWithCurrenciesRelativeTo(vc: view as! UIViewController, listGroupModel: listGroupModel)
    }
}
