//
//  CreateOrderCreateOrderRouter.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 22/03/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//
import UIKit.UIViewController

class CreateOrderRouter: CreateOrderRouterInput {
    func closeView(view: UIViewController) {
        view.close()
    }
    
    func openCurrencySearchVC(_ sourceVC: UIViewController, moduleOutput: SearchModuleOutput!) {
        let destinationModule = SearchModuleInitializer()
        guard let inputModule = destinationModule.viewController.output as? SearchModuleInput else {
            return
        }
        inputModule.setInputModule(output: moduleOutput)
        sourceVC.present(destinationModule.viewController, animated: true, completion: nil)
    }
}
