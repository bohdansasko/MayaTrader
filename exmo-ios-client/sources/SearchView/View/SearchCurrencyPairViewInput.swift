//
//  SearchViewInput.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

protocol SearchViewInput: class {

    /**
        @author TQ0oS
        Setup initial state of the view
    */

    func setupInitialState()
    func setSearchData(_ searchType: SearchViewController.SearchType, _ data: [SearchModel])
}
