//
//  SearchInteractorInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import Foundation

protocol SearchInteractorInput {
    func viewIsReady()
    func viewWillDisappear()
    func loadCurrenciesPairs()
}

protocol SearchInteractorOutput: class {
    func onDidLoadCurrenciesPairs(_ pairs: [SearchCurrencyPairModel])
}
