//
//  SearchCurrencyPairViewProtocols.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol SearchViewInput: class {
    
}

protocol SearchViewOutput: class {
    func viewIsReady()
    func closeVC()
    func onTouchCurrencyPair(rawName: String)
    func setSearchData(_ searchType: SearchViewController.SearchType, _ data: [SearchModel])
}
