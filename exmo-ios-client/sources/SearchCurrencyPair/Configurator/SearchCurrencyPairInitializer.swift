//
//  SearchCurrencyPairSearchCurrencyPairInitializer.swift
//  ExmoMobileClient
//
//  Created by TQ0oS on 01/07/2018.
//  Copyright © 2018 Roobik. All rights reserved.
//

import UIKit

class SearchCurrencyPairModuleInitializer: NSObject {

    //Connect with object on storyboard
    @IBOutlet weak var searchcurrencypairViewController: SearchCurrencyPairViewController!

    override func awakeFromNib() {

        let configurator = SearchCurrencyPairModuleConfigurator()
        configurator.configureModuleForViewInput(viewInput: searchcurrencypairViewController)
    }

}
