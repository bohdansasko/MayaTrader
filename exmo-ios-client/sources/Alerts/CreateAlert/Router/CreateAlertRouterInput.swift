//
//  CreateAlertCreateAlertRouterInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 14/05/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

protocol CreateAlertRouterInput {
    func close(uiViewController: UIViewController!)
    func openCurrencyPairsSearchView(data: [SearchModel], uiViewController: UIViewController!, callbackOnSelectCurrency: IntInVoidOutClosure?)
    func openSoundsSearchView(data: [SearchModel], uiViewController: UIViewController!, callbackOnSelectSound: IntInVoidOutClosure?)
}
