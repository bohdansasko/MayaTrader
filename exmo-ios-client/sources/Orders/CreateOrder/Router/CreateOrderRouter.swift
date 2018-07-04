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
    func openCurrencySearchView(view: UIViewController, callbackOnSelectCurrency: IntInVoidOutClosure?) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCurrencyPairViewController") as! SearchCurrencyPairViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.output.subscribeOnSelectCurrency(callback: callbackOnSelectCurrency)
        view.present(vc, animated: true, completion: nil)
    }
}
