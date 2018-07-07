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

    func openCurrencyPairsSearchView(data: [SearchModel], uiViewController: UIViewController!, callbackOnSelectCurrency: IntInVoidOutClosure?) {
        showSearchController(.Currencies, data, uiViewController, callbackOnSelectCurrency)
    }

    func openSoundsSearchView(data: [SearchModel], uiViewController: UIViewController!, callbackOnSelectSound: IntInVoidOutClosure?) {
        showSearchController(.Sounds, data, uiViewController, callbackOnSelectSound)
    }
    
    private func showSearchController(_ searchType: SearchCurrencyPairViewController.SearchType, _ data: [SearchModel], _ uiViewController: UIViewController!, _ callbackOnSelectCurrency: IntInVoidOutClosure?) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchCurrencyPairViewController") as! SearchCurrencyPairViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.output.setSearchData(searchType, data)
        vc.output.subscribeOnSelectCurrency(callback: callbackOnSelectCurrency)
        uiViewController.present(vc, animated: true, completion: nil)
    }
}
