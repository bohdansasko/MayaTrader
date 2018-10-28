//
//  WatchlistCurrenciesListWatchlistCurrenciesListRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 15/10/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class WatchlistCurrenciesListGroupSegueBlock: SegueBlock {
    private(set) var groupModel: WatchlistCurrenciesListGroup?
    
    init(dataModel: WatchlistCurrenciesListGroup?) {
        self.groupModel = dataModel
    }
}


class WatchlistCurrenciesListRouter: WatchlistCurrenciesListRouterInput {
    func closeVC(vc: UIViewController) {
        vc.close()
    }
    
    func openCurrenciesListWithCurrenciesRelativeTo(vc: UIViewController, listGroupModel: WatchlistCurrenciesListGroup) {
        let config = CurrenciesListModuleConfigurator()
        guard let moduleInput = config.viewController.output as? CurrenciesListModuleInput else { return }
        let segueBlock = WatchlistCurrenciesListGroupSegueBlock(dataModel: listGroupModel)
        moduleInput.setSegueBlock(segueBlock)
        vc.present(config.viewController, animated: true, completion: nil)
    }
}
