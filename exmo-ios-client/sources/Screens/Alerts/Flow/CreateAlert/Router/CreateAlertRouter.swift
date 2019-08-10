//
//  CreateAlertCreateAlertRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class CreateAlertRouter: CreateAlertRouterInput {
    func close(uiViewController: UIViewController!) {
        uiViewController.close()
    }

    func openCurrencyPairsSearchView(_ sourceVC: UIViewController, moduleOutput: SearchModuleOutput!) {
        let destinationModule = SearchModuleInitializer()
        guard let moduleInput = destinationModule.viewController.output as? SearchModuleInput else {
            return
        }
        moduleInput.setInputModule(output: moduleOutput)
        sourceVC.present(destinationModule.viewController, animated: true, completion: nil)
    }
}
