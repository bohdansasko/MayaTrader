//
//  SearchCurrencyPairViewProtocols.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol SearchViewInput: class {
    func updatePairsList(_ pairs: [SearchCurrencyPairModel])
}

protocol SearchViewOutput: class {
    func viewIsReady()
    func viewWillDisappear()
    func closeVC()
    func onTouchCurrencyPair(rawName: String)
}
