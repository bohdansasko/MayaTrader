//
//  CurrenciesGroupsRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation
import UIKit

class CurrenciesGroupsGroupSegueBlock: SegueBlock {
    private(set) var groupModel: CurrenciesGroupsGroup?
    
    init(dataModel: CurrenciesGroupsGroup?) {
        self.groupModel = dataModel
    }
}

protocol CurrenciesGroupsRouterInput {
    func closeVC(vc: UIViewController)
    func openCurrenciesListWithCurrenciesRelativeTo(vc: UIViewController, listGroupModel: CurrenciesGroupsGroup)
}

class CurrenciesGroupsRouter: CurrenciesGroupsRouterInput {
    func closeVC(vc: UIViewController) {
        vc.close()
    }
    
    func openCurrenciesListWithCurrenciesRelativeTo(vc: UIViewController, listGroupModel: CurrenciesGroupsGroup) {
        let config = CurrenciesListModuleConfigurator()
        guard let moduleInput = config.viewController.output as? CurrenciesListModuleInput else { return }
        let segueBlock = CurrenciesGroupsGroupSegueBlock(dataModel: listGroupModel)
        moduleInput.setSegueBlock(segueBlock)
        vc.present(config.viewController, animated: true, completion: nil)
    }
}
